module NewTweet.Action where

import NewTweet.Model exposing (Model)

type Action
    = Update String
    | AddTweet Model
