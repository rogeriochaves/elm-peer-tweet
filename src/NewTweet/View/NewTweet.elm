module NewTweet.View.NewTweet (..) where

import Html exposing (Html, div, textarea, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, on, targetValue)
import Action as RootAction exposing (..)
import Accounts.Action exposing (..)
import NewTweet.Action exposing (..)
import Model exposing (Model)
import Account.Model as Account


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
view address model account =
  div
    [ class "container" ]
    [ textarea
        [ class "materialize-textarea new-tweet"
        , on "input" targetValue (Signal.message address << ActionForNewTweet << Update)
        ]
        [ text model.newTweet.text
        ]
    , button
        [ class "btn", onClick address (ActionForAccounts <| AddTweetRequest { account = account, text = model.newTweet.text }) ]
        [ text "Tweet"
        ]
    ]
