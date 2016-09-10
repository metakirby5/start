'use strict';

// CSS
require('skeleton/css/normalize.css');
require('skeleton/css/skeleton.css');
require('./style');

var main = require('./Main').Main.fullscreen();
var yaml = require('js-yaml');
var $ = require('jquery');

var CONFIG = '/static/config.yaml';

$.ajax({
  url: CONFIG,
  success: function(data) {
    console.log(yaml.safeLoad(data));
  },
  error: function() {
    alert('Could not fetch ' + CONFIG + '!');
  },
});
