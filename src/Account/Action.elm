module Account.Action (..) where

import Account.Model exposing (Model, Head, Tweet)


type Action
  = Update Model
  | UpdateHead Head
  | AddTweet Tweet
