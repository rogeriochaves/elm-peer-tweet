module Account.Action (..) where

import Account.Model exposing (Model, Head, Tweet, FollowBlock)


type Action
  = Update Model
  | UpdateHead Head
  | AddTweet Tweet
  | AddFollowBlock FollowBlock
