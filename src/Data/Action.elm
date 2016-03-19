module Data.Action (..) where

import Account.Model as Account exposing (HeadHash)
import Account.Action as AccountAction
import Time exposing (Time)


type alias AddTweetRequestPayload =
  { account : Account.Model, text : String }


type alias AddFollowerRequestPayload =
  { account : Account.Model, hash : HeadHash }


type Action
  = AddTweetRequest AddTweetRequestPayload
  | AddFollowerRequest AddFollowerRequestPayload
  | UpdateUserAccount Account.Model
  | ActionForAccount HeadHash AccountAction.Action
  | CreateAccount HeadHash Time
