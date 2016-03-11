module Data.Action (..) where

import Account.Model as Account exposing (Hash)


type alias AddTweetRequestPayload =
  { account : Account.Model, text : String }


type alias AddFollowerRequestPayload =
  { account : Account.Model, hash : Hash }


type Action
  = AddTweetRequest AddTweetRequestPayload
  | AddFollowerRequest AddFollowerRequestPayload
  | UpdateAccount Account.Model
