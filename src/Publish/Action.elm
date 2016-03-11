module Publish.Action (..) where

import Account.Model exposing (Hash, Head, Tweet)


type Action
  = BeginPublish
  | PublishHead Head
  | DonePublishHead Hash
  | PublishTweet Tweet
  | DonePublishTweet Hash
