module Data.Ports (..) where

import Account.Model as Account
import Action exposing (..)
import Data.Action exposing (..)
import Ports exposing (jsMailbox, isJust, filterEmpty)


port accountStream : Signal Account.Model


port requestAddTweet : Signal (Maybe AddTweetRequestPayload)
port requestAddTweet =
  let
    getRequest action =
      case action of
        ActionForData (AddTweetRequest req) ->
          Just req

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


port requestAddFollower : Signal (Maybe AddFollowerRequestPayload)
port requestAddFollower =
  let
    getRequest action =
      case action of
        ActionForData (AddFollowerRequest req) ->
          Just req

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


accountInput : Signal Action.Action
accountInput =
  Signal.map (ActionForData << UpdateAccount) accountStream
