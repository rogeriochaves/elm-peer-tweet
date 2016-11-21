module Router.Cmd exposing (..)

import Router.Msg as Router exposing (Msg(..))
import Router.Routes exposing (Page(..), toPath, pathParser)
import Msg as RootMsg exposing (Msg(..))
import Router.Model exposing (Model)
import Accounts.Msg exposing (Msg(CreateAccount))
import Navigation


cmds : RootMsg.Msg -> Model -> Cmd RootMsg.Msg
cmds msg model =
    case msg of
        MsgForRouter (Go route) ->
            Navigation.newUrl (toPath route)

        MsgForRouter (UrlChange location) ->
            case pathParser location of
                Nothing ->
                    Navigation.modifyUrl (toPath model.page)

                Just page ->
                    Cmd.none

        MsgForAccounts (CreateAccount _ _ _) ->
            Navigation.newUrl (toPath TimelineRoute)

        _ ->
            Cmd.none
