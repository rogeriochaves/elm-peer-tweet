module Publish.Action where

import Data.Model exposing (Head, Tweet)

type Action
    = BeginPublish
    | PublishHead Head
    | DonePublishHead Head
    | PublishTweet Tweet
    | DonePublishTweet Tweet
