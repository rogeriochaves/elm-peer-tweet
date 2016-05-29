module NewTweet.View.NewTweet exposing (..)

import Html exposing (Html, div, textarea, text, button)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, on, targetValue)
import Msg as RootMsg exposing (..)
import Accounts.Msg exposing (..)
import NewTweet.Msg exposing (..)
import Model exposing (Model)
import Account.Model as Account
import String exposing (length)
import Utils.Utils exposing (onEnter)


view : Model -> Account.Model -> Html RootMsg.Msg
view model account =
  let
    tweetMsg =
      MsgForAccounts <| AddTweetRequest { account = account, text = model.newTweet.text }
  in
    div
      [ class "container" ]
      [ textarea
          [ class "materialize-textarea new-tweet"
          , on "input" (Json.map (MsgForNewTweet << Update) targetValue)
          , onEnter tweetMsg
          , value model.newTweet.text
          ]
          []
      , div
          [ class "new-tweet-actions" ]
          [ div [ class "characters-left grey-text" ] [ text <| toString <| 140 - (length model.newTweet.text) ]
          , button
              [ class "btn small", onClick tweetMsg ]
              [ text "Tweet"
              ]
          ]
      ]
