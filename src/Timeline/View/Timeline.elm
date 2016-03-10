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

    followBlocks =
      model.data.followBlocks
  in
    div []
      [ div [] (List.map (Tweet.view timestamp) tweets)
      , div [] [text "following:"]
      , div [] (List.map (text << toString << .l) followBlocks)
      ]
