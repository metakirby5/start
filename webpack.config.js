'use strict';

const path = require('path')
    , webpack = require('webpack')
    , merge = require('webpack-merge');

const
    // Environment
      ENV = process.env.npm_lifecycle_event

    // Module folders
    , VENDORS = ['elm-stuff', 'node_modules', 'bower_components']
    , VENDOR_RE = new RegExp(VENDORS.join('|'))

    // Input and output folders
    , SRC_PATH = path.join(__dirname, 'src')
    , BUILD_PATH = path.join(__dirname, 'static')

    // If you change these, you must change the script tags in index.html
    , PUBLIC_PATH = '/static/'
    , SRC_BUNDLE = 'main'
    , VENDOR_BUNDLE = 'vendor';

// Check if module is vendor, for chunking
const isVendor = (module) => {
  var r = module.userRequest;
  return typeof r === 'string' && r.match(VENDOR_RE);
}

var config = {
  // What file to start at
  entry: [path.join(SRC_PATH, `${SRC_BUNDLE}.js`)],

  // Where to output
  output: {
    path: BUILD_PATH,
    publicPath: PUBLIC_PATH,
    filename: '[name].js',
  },

  // Where to load modules from
  resolve: {
    modulesDirectories: VENDORS,
    extensions: ['', '.elm', '.styl', '.js', '.css']
  },

  // Stylus options
  stylus: {
    use: [require('nib')()],
    import: ['~nib/lib/nib/index.styl'],
    preferPathResolver: 'webpack',
  },

  // Stylint options
  stylint: {
    config: '.stylintrc',
  },

  // Module loading options
  module: {
    // Linters, etc
    preLoaders: [
      { // Stylint
        test: /\.styl/,
        loader: 'stylint',
        exclude: VENDOR_RE,
      },
    ],

    // Files to load
    loaders: [
      { // Elm
        test: /\.elm$/,
        loaders: ['elm-webpack'],
      },
      { // Stylus
        test: /\.styl$/,
        exclude: /\.u\.styl/,
        loaders: ['style', 'css', 'stylus'],
      },
      { // Plain CSS
        test: /\.css$/,
        loaders: ['style', 'css'],
      },
      { // Media
        test: /\.(png|jpe?g|gif|svg|woff2?|eot|ttf)$/,
        loaders: ['url'],
      },
    ],
  },

  plugins: [
    // Separate vendor bundle
    new webpack.optimize.CommonsChunkPlugin({
      name: VENDOR_BUNDLE,
      minChunks: isVendor,
    }),
  ],
};

// Options based on environment
switch (ENV) {
  case 'start': // Development
    console.log('Running development server...');
    module.exports = merge(config, {
      // Source maps
      devtool: 'cheap-module-eval-source-map',

      // -- Hot loading --

      module: {
        loaders: [
          {
            test: /\.elm/,
            loaders: ['elm-hot'],
          },
        ],
      },

      plugins: [new webpack.HotModuleReplacementPlugin()],

      devServer: {
        // Adjust entry point
        inline: true,

        // Show progress
        progress: true,

        // Hot reloading
        hot: true,

        // Allow routing
        historyApiFallback: true,

        // Display options
        stats: {
          // Do not show list of hundreds of files included in a bundle
          chunkModules: false,
          colors: true,
        },
      },
    });
    break;

  case 'build': // Production
    console.log('Building production scripts...');
    module.exports = merge(config, {
      plugins: [
        // Production environment variable
        new webpack.DefinePlugin({
          'process.env': {
            'NODE_ENV': JSON.stringify('production'),
          },
        }),

        // Deduplicate
        new webpack.optimize.DedupePlugin(),

        // Minify
        new webpack.optimize.UglifyJsPlugin({
          compress: {warnings: false},
        }),
      ],
    });
    break;
}
