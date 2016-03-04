module NewTweet.View.NewTweet where

import Html exposing (Html, div, textarea, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, on, targetValue)
import Action as RootAction exposing (..)
import Data.Action exposing (..)
import NewTweet.Action exposing (..)
import Model exposing (Model)

view : Signal.Address RootAction.Action -> Model -> Html
view address model =
  div [] [
    textarea [
      class "new-tweet",
      on "input" targetValue (Signal.message address << ActionForNewTweet << Update)
    ] [
      text model.newTweet.text
    ],
    button [onClick address (ActionForData <| AddTweetRequest { data = model.data, text = model.newTweet.text } )] [
      text "Tweet"
    ]
  ]