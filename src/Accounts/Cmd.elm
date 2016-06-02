module Accounts.Cmd exposing (cmds)

import Msg as RootMsg exposing (..)
import Accounts.Model exposing (Model, findAccount)
import Accounts.Msg as AccountsMsg exposing (Msg(CreateAccount, UpdateUserAccount, AddTweetRequest, AddFollowerRequest))
import Accounts.Ports exposing (requestAddTweet, requestAddFollower, setStorage)
import Accounts.Update exposing (update)
import Download.Msg as DownloadMsg exposing (Msg(DoneDownloadHead, DoneDownloadTweet, DoneDownloadFollowBlock))


cmds : RootMsg.Msg -> Model -> Cmd RootMsg.Msg
cmds msg model =
    case msg of
        MsgForAccounts accountsMsg ->
            Cmd.batch
                [ cmdsAccounts accountsMsg
                , setStorage (update msg model)
                ]

        MsgForDownload (DoneDownloadHead _) ->
            setStorage (update msg model)

        MsgForDownload (DoneDownloadTweet _) ->
            setStorage (update msg model)

        MsgForDownload (DoneDownloadFollowBlock _) ->
            setStorage (update msg model)

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
