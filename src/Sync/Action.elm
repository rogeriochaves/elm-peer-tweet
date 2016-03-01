module Sync.Action where

import Data.Model exposing (Head, Tweet)

type Action
    = BeginSync
    | PublishHead Head
    | DonePublishHead Head
    | PublishTweet Tweet
    | DonePublishTweet Tweet
