module Topbar.View.Topbar where

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import NewTweet.View.NewTweet as NewTweet
import Action exposing (Action)
import Model exposing (Model)

view : Signal.Address Action -> Model -> Html
view address model =
  div [] [
    div [class "top-bar"] [
      text "Timeline"
    ],
    div [] [
      NewTweet.view address model.newTweet
    ]
  ]
