module Timeline.View.Feed (..) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Account.Model as Account
import Timeline.View.Tweet as Tweet
import Action exposing (Action)


view : Signal.Address Action -> Model -> Account.Model -> Html
view address model account =
  let
    timestamp =
      model.dateTime.timestamp

    tweets =
      account.tweets
  in
    ul
      [ class "collection" ]
      (List.map (\tweet -> Tweet.view address timestamp { head = account.head, tweet = tweet}) tweets)
