module Accounts.Cmd exposing (cmds)

import Msg as RootMsg exposing (..)
import Accounts.Model exposing (Model, findAccount)
import Accounts.Msg as AccountsMsg exposing (Msg(CreateAccount, UpdateUserAccount, AddTweetRequest, AddFollowerRequest))
import Accounts.Ports exposing (requestAddTweet, requestAddFollower, setStorage)


cmds : RootMsg.Msg -> Model -> Cmd RootMsg.Msg
cmds msg model =
    case msg of
        MsgForAccounts accountsMsg ->
            Cmd.batch
                [ cmdsAccounts accountsMsg
                , setStorage model
                ]

        _ ->
            Cmd.none


cmdsAccounts : AccountsMsg.Msg -> Cmd RootMsg.Msg
cmdsAccounts msg =
    case msg of
        AddTweetRequest req ->
            requestAddTweet req

        AddFollowerRequest req ->
            requestAddFollower req

        _ ->
            Cmd.none
