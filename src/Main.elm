port module Main exposing (..)

import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App

main = text "Hello, World"

-- main : Program (Maybe Model)
-- main = App.programWithFlags
--   { init          = init
--   , view          = view
--   , update        = update
--   , subscriptions = \_ -> Sub.none }

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
--     , entries : Maybe (List Tree) }

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
