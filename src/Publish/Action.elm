module Publish.Msg (..) where

import Account.Model exposing (HeadHash, TweetHash, FollowBlockHash, Head, Tweet, FollowBlock)
import Account.Msg exposing (TweetIdentifier, TweetData, FollowBlockIdentifier, FollowBlockData)


type Msg
  = BeginPublish
  | PublishHead Head
  | DonePublishHead HeadHash
  | PublishTweet TweetData
  | DonePublishTweet TweetIdentifier
  | PublishFollowBlock FollowBlockData
  | DonePublishFollowBlock FollowBlockIdentifier
