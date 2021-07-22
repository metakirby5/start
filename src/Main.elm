port module Main exposing (..)

import Debug
import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Json
import Task

main = App.program
  { init = init
  , view = view
  , update = update
  , subscriptions = \_ -> Sub.none }

type alias Model =
  { state : State
  , topic : String
  , gif : String }
type State = Init | Gif | Loading | Error
init : (Model, Cmd Msg)
init = (Model Init "" "", Cmd.none)

type Msg
  = NoOp
  | SetTopic String
  | GetGif
  | GotGif String
  | NotGif Http.Error
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      model ! []
    SetTopic topic ->
      {model | topic = topic} ! []
    GetGif ->
      {model | state = Loading} ! [getGif model.topic]
    GotGif url ->
      {model | gif = url, state = Gif} ! []
    NotGif err ->
      {model | state = Error} ! []

getGif : String -> Cmd Msg
getGif topic =
  let api = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag="
  in let decode = Json.at ["data", "image_url"] Json.string
  in Task.perform NotGif GotGif <| Http.get decode <| api ++ topic

view : Model -> Html Msg
view model =
  let content = case model.state of
    Init -> h1 [class "twelve columns"] [text "Enter topic!"]
    Gif -> img [class "twelve columns" , src model.gif] []
    Loading -> h1 [class "twelve columns"] [text "Loading..."]
    Error -> h1 [class "twelve columns"] [text "Error!"]
  in div [class "main"]
    [ div [class "row"]
      [ input
        [ class "twelve columns"
        , type' "text"
        , placeholder "Topic"
        , value model.topic
        , onInput SetTopic
        , onEnter GetGif ] []
      , content ]]

onEnter : Msg -> Attribute Msg
onEnter msg =
  let tagger code = if code == 13 then msg else NoOp
  in on "keydown" (Json.map tagger keyCode)

-- main : Program (Maybe Model)
-- main = App.programWithFlags
--   { init          = init
--   , view          = view
--   , update        = update
--   , subscriptions = \_ -> Sub.none
--   }

-- -- Models
-- type alias Model = { options : Options, tree: Tree }
-- type alias Options = { startSearching : Bool }
-- type Tree
--   = Root (List Tree)
--   | Node
--     { key     : String
--     , name    : String
--     , link    : String
--     , search  : String
--     , entries : Maybe (List Tree)
--     }

-- -- Updates
-- type Msg
--   = Nil

-- update : Msg -> Model -> (Model, Cmd Msg)
-- update msg model =
--   case msg of
--     Nil -> (model, Cmd.none)

-- -- Views
-- view : Model -> Html Msg
-- view model =
--   div [] [ text "Hello, World" ]
