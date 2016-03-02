module Publish.Ports where

import Data.Model as Data
import Action exposing (..)
import Publish.Action exposing (..)
import Ports exposing (jsMailbox, isJust, filterEmpty)

port publishHeadStream : Signal (Maybe Data.Head)

port requestPublishHead : Signal (Maybe Data.Head)
port requestPublishHead =
  let getRequest action =
    case action of
      ActionForPublish (PublishHead head) -> Just head
      _ -> Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty

publishHeadInput : Signal Action.Action
publishHeadInput =
  Signal.map (\_ -> NoOp) publishHeadStream

port publishTweetStream : Signal (Maybe Data.Tweet)

port requestPublishTweet : Signal (Maybe Data.Tweet)
port requestPublishTweet =
  let getRequest action =
    case action of
      ActionForPublish (PublishTweet tweet) -> Just tweet
      _ -> Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty

publishTweetInput : Signal Action.Action
publishTweetInput =
  Signal.map (\_ -> NoOp) publishTweetStream
