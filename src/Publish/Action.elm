module Publish.Action (..) where

import Account.Model exposing (HeadHash, TweetHash, FollowBlockHash, Head, Tweet, FollowBlock)


type alias PublishTweetPayload =
  { headHash : HeadHash, tweet : Tweet }


type alias DonePublishTweetPayload =
  { headHash : HeadHash, tweetHash : TweetHash }


type alias PublishFollowBlockPayload =
  { headHash : HeadHash, followBlock : FollowBlock }


type alias DonePublishFollowBlockPayload =
  { headHash : HeadHash, followBlockHash : FollowBlockHash }


type Action
  = BeginPublish
  | PublishHead Head
  | DonePublishHead HeadHash
  | PublishTweet PublishTweetPayload
  | DonePublishTweet DonePublishTweetPayload
  | PublishFollowBlock PublishFollowBlockPayload
  | DonePublishFollowBlock DonePublishFollowBlockPayload
