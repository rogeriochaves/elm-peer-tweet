module Publish.Action (..) where

import Data.Model exposing (Hash, Head, Tweet)


type Action
  = BeginPublish
  | PublishHead Head
  | DonePublishHead Hash
  | PublishTweet Tweet
  | DonePublishTweet Hash
