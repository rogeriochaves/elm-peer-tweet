module Data.Ports where

import Data.Model as Data
import Action exposing (..)
import Data.Action exposing (..)
import Ports exposing (jsMailbox, isJust, filterEmpty)

port dataStream : Signal Data.Model

port requestAddTweet : Signal (Maybe AddTweetRequestData)
port requestAddTweet =
  let getRequest action =
    case action of
      ActionForData (AddTweetRequest req) -> Just req
      _ -> Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty

dataInput : Signal Action.Action
dataInput =
  Signal.map (ActionForData << UpdateData) dataStream
