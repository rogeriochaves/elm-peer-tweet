module Topbar.View.Topbar where

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Topbar.View.Tweet

view : Html
view =
  div [] [
    div [class "top-bar"] [
      text "Timeline"
    ],
    div [] [
      Topbar.View.Tweet.view
    ]
  ]
