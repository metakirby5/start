port module Main exposing (..)

import Debug
import Html exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Html.Attributes exposing (..)

main = App.beginnerProgram
  { model = model
  , view = view
  , update = update }

type alias Model = Int
model : Model
model = 0

type Msg = Increment | Decrement | Reset
update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment -> model + 1
    Decrement -> model - 1
    Reset -> 0

view : Model -> Html Msg
view model =
  div [style [("padding", "4%")]]
    [ div [class "row"]
      [ div [class "twelve columns", style [("text-align", "center")]]
        [text (toString model)] ]
    , div [class "row", style [("margin-top", "4%")]]
      [ button [class "one-third column", onClick Decrement] [text "-"]
      , button [class "one-third column", onClick Reset] [text "Reset"]
      , button [class "one-third column", onClick Increment] [text "+"]
      ]
    ]

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
