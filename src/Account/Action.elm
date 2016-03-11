module Account.Action (..) where

import Account.Model as Account exposing (Hash)


type alias AddTweetRequestAccount =
  { account : Account.Model, text : String }


type alias AddFollowerRequestAccount =
  { account : Account.Model, hash : Hash }


type Action
  = AddTweetRequest AddTweetRequestAccount
  | AddFollowerRequest AddFollowerRequestAccount
  | UpdateAccount Account.Model
