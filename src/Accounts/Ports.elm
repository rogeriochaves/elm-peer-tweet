module Accounts.Ports (..) where

import Account.Model as Account
import Msg exposing (..)
import Accounts.Msg exposing (..)
import Ports exposing (jsMailbox)
import Utils.Utils exposing (isJust, filterEmpty)


port accountStream : Signal (Maybe Account.Model)
port requestAddTweet : Signal (Maybe AddTweetRequestPayload)
port requestAddTweet =
  let
    getRequest msg =
      case msg of
        MsgForAccounts (AddTweetRequest req) ->
          Just req

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


port requestAddFollower : Signal (Maybe AddFollowerRequestPayload)
port requestAddFollower =
  let
    getRequest msg =
      case msg of
        MsgForAccounts (AddFollowerRequest req) ->
          Just req

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


accountInput : Signal Msg.Msg
accountInput =
  Signal.map
    (Maybe.map (MsgForAccounts << UpdateUserAccount) >> Maybe.withDefault Msg.NoOp)
    accountStream
