module Publish.Ports (..) where

import Account.Model as Account exposing (Head, Tweet, Hash)
import Msg as RootMsg exposing (..)
import Publish.Msg exposing (..)
import Ports exposing (jsMailbox)
import Utils.Utils exposing (isJust, filterEmpty)
import Publish.Msg exposing (..)
import Time exposing (every, minute)
import Account.Msg exposing (TweetIdentifier, TweetData, FollowBlockIdentifier, FollowBlockData)


requestPublish : Signal RootMsg.Msg
requestPublish =
  (every <| 5 * minute)
    |> Signal.map (always <| MsgForPublish BeginPublish)


port publishHeadStream : Signal (Maybe Hash)


port requestPublishHead : Signal (Maybe Head)
port requestPublishHead =
  let
    getRequest msg =
      case msg of
        MsgForPublish (PublishHead head) ->
          Just head

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


publishHeadInput : Signal RootMsg.Msg
publishHeadInput =
  Signal.map (Maybe.map (MsgForPublish << DonePublishHead) >> Maybe.withDefault NoOp) publishHeadStream


port publishTweetStream : Signal (Maybe TweetIdentifier)


port requestPublishTweet : Signal (Maybe TweetData)
port requestPublishTweet =
  let
    getRequest msg =
      case msg of
        MsgForPublish (PublishTweet tweet) ->
          Just tweet

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


publishTweetInput : Signal RootMsg.Msg
publishTweetInput =
  Signal.map (Maybe.map (MsgForPublish << DonePublishTweet) >> Maybe.withDefault NoOp) publishTweetStream



port publishFollowBlockStream : Signal (Maybe FollowBlockIdentifier)


port requestPublishFollowBlock : Signal (Maybe FollowBlockData)
port requestPublishFollowBlock =
  let
    getRequest msg =
      case msg of
        MsgForPublish (PublishFollowBlock tweet) ->
          Just tweet

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


publishFollowBlockInput : Signal RootMsg.Msg
publishFollowBlockInput =
  Signal.map (Maybe.map (MsgForPublish << DonePublishFollowBlock) >> Maybe.withDefault NoOp) publishFollowBlockStream
