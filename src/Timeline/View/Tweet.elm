module Timeline.View.Tweet where

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Data.Model exposing (Tweet)

view : Tweet -> Html
view tweet =
  div [class "tweet"] [
    text "Fulano",
    div [class "minutes-ago"] [
      text <| toString tweet.d
    ],
    div [] [
      text tweet.t
    ],
    div [class "avatar"] [
      div [class "default-avatar ion-person"] []
    ]
  ]
