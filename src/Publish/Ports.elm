port module Publish.Ports exposing (..)

import Account.Model as Account exposing (Head, Tweet, Hash)
import Msg as RootMsg exposing (..)
import Publish.Msg exposing (..)
import Time exposing (every, minute)
import Account.Msg exposing (TweetIdentifier, TweetData, FollowBlockIdentifier, FollowBlockData)


requestPublish : Sub RootMsg.Msg
requestPublish =
    MsgForPublish BeginPublish
        |> always
        |> every (5 * minute)


port publishHeadStream : (Maybe Hash -> msg) -> Sub msg


port requestPublishHead : Head -> Cmd msg


publishHeadInput : Sub RootMsg.Msg
publishHeadInput =
    publishHeadStream (Maybe.map (MsgForPublish << DonePublishHead) >> Maybe.withDefault NoOp)


port publishTweetStream : (Maybe TweetIdentifier -> msg) -> Sub msg


port requestPublishTweet : TweetData -> Cmd msg


publishTweetInput : Sub RootMsg.Msg
publishTweetInput =
    publishTweetStream (Maybe.map (MsgForPublish << DonePublishTweet) >> Maybe.withDefault NoOp)


port publishFollowBlockStream : (Maybe FollowBlockIdentifier -> msg) -> Sub msg


port requestPublishFollowBlock : FollowBlockData -> Cmd msg


publishFollowBlockInput : Sub RootMsg.Msg
publishFollowBlockInput =
    publishFollowBlockStream (Maybe.map (MsgForPublish << DonePublishFollowBlock) >> Maybe.withDefault NoOp)
