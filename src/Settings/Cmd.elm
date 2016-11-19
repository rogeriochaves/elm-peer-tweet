module Settings.Cmd exposing (cmds)

import Msg as RootMsg exposing (Msg(MsgForSettings, MsgForAccounts, MsgForPublish))
import Model exposing (Model)
import Settings.Msg exposing (Msg(SaveSettings))
import Accounts.Msg exposing (Msg(UpdateUserAccount))
import Accounts.Model exposing (getUserAccount)
import Task exposing (andThen, succeed, perform)


cmds : RootMsg.Msg -> Model -> Cmd RootMsg.Msg
cmds msg model =
    let
        updatedUser userAccount head =
            { userAccount | head = { head | a = model.settings.avatar, d = model.dateTime.timestamp } }

        updateAccountCmd userAccount =
            succeed (MsgForAccounts <| UpdateUserAccount <| updatedUser userAccount userAccount.head)
                |> perform identity identity
    in
        case msg of
            MsgForSettings SaveSettings ->
                getUserAccount model
                    |> Maybe.map updateAccountCmd
                    |> Maybe.withDefault Cmd.none

            _ ->
                Cmd.none
