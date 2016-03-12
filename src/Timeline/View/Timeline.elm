module Timeline.View.Timeline (..) where

import Html exposing (Html, div, text)
import Model exposing (Model)
import Account.Model as Account
import Timeline.View.Tweet as Tweet


view : Model -> Account.Model -> Html
view model account =
  let
    timestamp =
      model.dateTime.timestamp

    tweets =
      account.tweets

    followBlocks =
      account.followBlocks
  in
    div
      []
      [ div [] (List.map (Tweet.view timestamp) tweets)
      , div [] [ text "following:" ]
      , div [] (List.map (text << toString << .l) followBlocks)
      ]
