module Authentication.Cmd exposing (cmds)

import Msg as RootMsg exposing (..)
import Authentication.Msg exposing (Msg(CreateKeys, Login))
import Authentication.Ports exposing (requestCreateKeys, requestLogin)


cmds : RootMsg.Msg -> Cmd RootMsg.Msg
cmds msg =
    case msg of
        MsgForAuthentication CreateKeys ->
            requestCreateKeys ()

        MsgForAuthentication (Login keys) ->
            requestLogin keys

        _ ->
            Cmd.none
