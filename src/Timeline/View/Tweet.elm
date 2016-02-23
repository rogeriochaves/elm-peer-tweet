module Timeline.View.Tweet where

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)

view : Html
view =
  div [class "tweet"] [
    text "Fulano",
    div [class "minutes-ago"] [
      text "5 minutes ago"
    ],
    div [] [
      text "lorem ipsum dolor sit amet"
    ],
    div [class "avatar"] [
      div [class "default-avatar ion-person"] []
    ]
  ]
