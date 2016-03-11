module Account.Ports (..) where

import Account.Model as Account
import Action exposing (..)
import Account.Action exposing (..)
import Ports exposing (jsMailbox, isJust, filterEmpty)


port accountStream : Signal Account.Model


port requestAddTweet : Signal (Maybe AddTweetRequestAccount)
port requestAddTweet =
  let
    getRequest action =
      case action of
        ActionForAccount (AddTweetRequest req) ->
          Just req

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


port requestAddFollower : Signal (Maybe AddFollowerRequestAccount)
port requestAddFollower =
  let
    getRequest action =
      case action of
        ActionForAccount (AddFollowerRequest req) ->
          Just req

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


accountInput : Signal Action.Action
accountInput =
  Signal.map (ActionForAccount << UpdateAccount) accountStream
