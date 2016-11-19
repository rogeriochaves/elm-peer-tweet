module Router.Cmd exposing (..)

import Router.Msg as Router exposing (Msg(..))
import Router.Routes exposing (Page(..), toPath)
import Msg as RootMsg exposing (Msg(..))
import Accounts.Msg exposing (Msg(CreateAccount))
import Navigation


cmds : RootMsg.Msg -> Cmd RootMsg.Msg
cmds msg =
    case msg of
        MsgForRouter (Go route) ->
            Navigation.newUrl (toPath route)

        MsgForAccounts (CreateAccount _ _ _) ->
            Navigation.newUrl (toPath TimelineRoute)

        _ ->
            Cmd.none
