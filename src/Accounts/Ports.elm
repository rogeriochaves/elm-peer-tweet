port module Accounts.Ports exposing (..)

import Account.Model as Account
import Accounts.Msg exposing (..)
import Accounts.Model as Accounts
import Msg as RootMsg exposing (Msg(MsgForAccounts, NoOp))


port accountStream : (Maybe Account.Model -> msg) -> Sub msg


port requestAddTweet : AddTweetRequestPayload -> Cmd msg


port requestAddFollower : AddFollowerRequestPayload -> Cmd msg


accountInput : Sub RootMsg.Msg
accountInput =
    accountStream (Maybe.map (MsgForAccounts << UpdateUserAccount) >> Maybe.withDefault NoOp)


port setStorage : Accounts.Model -> Cmd msg
