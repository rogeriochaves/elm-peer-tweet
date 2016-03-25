module Timeline.View.Timeline (..) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Account.Model as Account
import Accounts.Model exposing (timeline)
import Timeline.View.Tweet as Tweet
import Topbar.View.Topbar as Topbar
import Action exposing (Action)
import NewTweet.View.NewTweet as NewTweet


view : Signal.Address Action -> Model -> Account.Model -> Html
view address model userAccount =
  let
    timestamp =
      model.dateTime.timestamp

    items =
      timeline model.accounts userAccount
  in
    div
      []
      [ Topbar.view address model "Timeline"
      , NewTweet.view address model userAccount
      , ul [ class "collection" ] (List.map (Tweet.view address timestamp) items)
      ]
