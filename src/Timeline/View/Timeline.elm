module Timeline.View.Timeline exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Account.Model as Account
import Accounts.Model exposing (timeline)
import Timeline.View.Tweet as Tweet
import Topbar.View.Topbar as Topbar
import Msg exposing (Msg)
import NewTweet.View.NewTweet as NewTweet


view : Model -> Account.Model -> Html Msg
view model userAccount =
  let
    timestamp =
      model.dateTime.timestamp

    items =
      timeline model.accounts userAccount
  in
    div
      []
      [ Topbar.view model "Timeline"
      , NewTweet.view model userAccount
      , ul [ class "collection" ] (List.map (Tweet.view timestamp) items)
      ]
