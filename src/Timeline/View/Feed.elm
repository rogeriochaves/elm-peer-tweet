module Timeline.View.Feed exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Account.Model as Account
import Timeline.View.Tweet as Tweet
import Msg exposing (Msg)


view : Model -> Account.Model -> Html Msg
view model account =
  let
    timestamp =
      model.dateTime.timestamp

    tweets =
      account.tweets
  in
    ul
      [ class "collection" ]
      (List.map (\tweet -> Tweet.view timestamp { head = account.head, tweet = tweet}) tweets)
