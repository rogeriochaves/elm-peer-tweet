module Accounts.Msg exposing (..)

import Account.Model as Account exposing (HeadHash, Name)
import Account.Msg as AccountMsg
import Time exposing (Time)


type alias AddTweetRequestPayload =
  { account : Account.Model, text : String }


type alias AddFollowerRequestPayload =
  { account : Account.Model, hash : HeadHash }


type Msg
  = AddTweetRequest AddTweetRequestPayload
  | AddFollowerRequest AddFollowerRequestPayload
  | UpdateUserAccount Account.Model
  | MsgForAccount HeadHash AccountMsg.Msg
  | CreateAccount HeadHash Name Time
