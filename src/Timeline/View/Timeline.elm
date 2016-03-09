module Timeline.View.Timeline (..) where

import Html exposing (Html, div, text)
import Model exposing (Model)
import Timeline.View.Tweet as Tweet


view : Model -> Html
view model =
  let
    timestamp =
      model.dateTime.timestamp

    tweets =
      model.data.tweets
  in
    div
      []
      (List.map (Tweet.view timestamp) tweets)
