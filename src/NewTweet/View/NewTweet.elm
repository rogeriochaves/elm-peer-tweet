module NewTweet.View.NewTweet (..) where

import Html exposing (Html, div, textarea, text, button)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, on, targetValue)
import Action as RootAction exposing (..)
import Accounts.Action exposing (..)
import NewTweet.Action exposing (..)
import Model exposing (Model)
import Account.Model as Account
import String exposing (length)
import Utils exposing (onEnter)


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
view address model account =
  let
    tweetAction =
      ActionForAccounts <| AddTweetRequest { account = account, text = model.newTweet.text }
  in
    div
      [ class "container" ]
      [ textarea
          [ class "materialize-textarea new-tweet"
          , on "input" targetValue (Signal.message address << ActionForNewTweet << Update)
          , onEnter address tweetAction
          , value model.newTweet.text
          ]
          []
      , div
          [ class "new-tweet-actions" ]
          [ div [ class "characters-left grey-text" ] [ text <| toString <| 140 - (length model.newTweet.text) ]
          , button
              [ class "btn small", onClick address tweetAction ]
              [ text "Tweet"
              ]
          ]
      ]
