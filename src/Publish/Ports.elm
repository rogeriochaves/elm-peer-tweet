module Publish.Ports (..) where

import Account.Model as Account exposing (Head, Tweet, Hash)
import Action as RootAction exposing (..)
import Publish.Action exposing (..)
import Ports exposing (jsMailbox, isJust, filterEmpty)
import Publish.Action exposing (..)
import Time exposing (every, second)
import Account.Action exposing (TweetIdentifier, TweetData, FollowBlockIdentifier, FollowBlockData)


requestPublish : Signal RootAction.Action
requestPublish =
  (every <| 30 * second)
    |> Signal.map (always <| ActionForPublish BeginPublish)


port publishHeadStream : Signal (Maybe Hash)


port requestPublishHead : Signal (Maybe Head)
port requestPublishHead =
  let
    getRequest action =
      case action of
        ActionForPublish (PublishHead head) ->
          Just head

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


publishHeadInput : Signal RootAction.Action
publishHeadInput =
  Signal.map (Maybe.map (ActionForPublish << DonePublishHead) >> Maybe.withDefault NoOp) publishHeadStream


port publishTweetStream : Signal (Maybe TweetIdentifier)


port requestPublishTweet : Signal (Maybe TweetData)
port requestPublishTweet =
  let
    getRequest action =
      case action of
        ActionForPublish (PublishTweet tweet) ->
          Just tweet

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


publishTweetInput : Signal RootAction.Action
publishTweetInput =
  Signal.map (Maybe.map (ActionForPublish << DonePublishTweet) >> Maybe.withDefault NoOp) publishTweetStream



port publishFollowBlockStream : Signal (Maybe FollowBlockIdentifier)


port requestPublishFollowBlock : Signal (Maybe FollowBlockData)
port requestPublishFollowBlock =
  let
    getRequest action =
      case action of
        ActionForPublish (PublishFollowBlock tweet) ->
          Just tweet

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


publishFollowBlockInput : Signal RootAction.Action
publishFollowBlockInput =
  Signal.map (Maybe.map (ActionForPublish << DonePublishFollowBlock) >> Maybe.withDefault NoOp) publishFollowBlockStream
