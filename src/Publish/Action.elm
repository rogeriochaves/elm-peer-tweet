module Publish.Action (..) where

import Account.Model exposing (HeadHash, TweetHash, Head, Tweet)


type alias PublishTweetPayload =
  { headHash : HeadHash, tweet : Tweet }


type alias DonePublishTweetPayload =
  { headHash : HeadHash, tweetHash : TweetHash }


type Action
  = BeginPublish
  | PublishHead Head
  | DonePublishHead HeadHash
  | PublishTweet PublishTweetPayload
  | DonePublishTweet DonePublishTweetPayload
