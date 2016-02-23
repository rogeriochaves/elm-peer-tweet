module Topbar.View.Tweet where

import Html exposing (Html, div, textarea, text, button)
import Html.Attributes exposing (class)

view : Html
view =
  div [] [
    textarea [class "new-tweet"] [
      text ""
    ],
    button [] [
      text "Tweet"
    ]
  ]
