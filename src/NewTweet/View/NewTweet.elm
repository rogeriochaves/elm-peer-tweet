module NewTweet.View.NewTweet where

import Html exposing (Html, div, textarea, text, button)
import Html.Attributes exposing (class)
import Action exposing (Action)
import NewTweet.Model exposing (Model)

view : Signal.Address Action -> Model -> Html
view address newTweet =
  div [] [
    textarea [class "new-tweet"] [
      text newTweet.text
    ],
    button [] [
      text "Tweet"
    ]
  ]
