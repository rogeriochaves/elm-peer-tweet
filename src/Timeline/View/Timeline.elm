module Timeline.View.Timeline where

import Html exposing (Html, div, text)
import Timeline.View.Tweet

view : Html
view =
  div [] [
    Timeline.View.Tweet.view,
    Timeline.View.Tweet.view,
    Timeline.View.Tweet.view,
    Timeline.View.Tweet.view
  ]
