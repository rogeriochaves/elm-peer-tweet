module Publish.Action (..) where

import Account.Model exposing (HeadHash, TweetHash, FollowBlockHash, Head, Tweet, FollowBlock)
import Account.Action exposing (TweetIdentifier, TweetData, FollowBlockIdentifier, FollowBlockData)


type Action
  = BeginPublish
  | PublishHead Head
  | DonePublishHead HeadHash
  | PublishTweet TweetData
  | DonePublishTweet TweetIdentifier
  | PublishFollowBlock FollowBlockData
  | DonePublishFollowBlock FollowBlockIdentifier
