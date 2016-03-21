module Timeline.View.Timeline (..) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Account.Model as Account
import Timeline.View.Tweet as Tweet
import Topbar.View.Topbar as Topbar
import Action exposing (Action)
import NewTweet.View.NewTweet as NewTweet


view : Signal.Address Action -> Model -> Account.Model -> Html
view address model account =
  let
    timestamp =
      model.dateTime.timestamp

    tweets =
      account.tweets

    followBlocks =
      account.followBlocks
  in
    Topbar.view address model <|
    div
      []
      [ NewTweet.view address model account
      , ul [ class "collection" ] (List.map (Tweet.view timestamp) tweets)
      , div [] [ text "following:" ]
      , div [] (List.map (text << toString << .l) followBlocks)
      ]
