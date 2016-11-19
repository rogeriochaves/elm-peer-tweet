port module Authentication.Ports exposing (..)

import Account.Model as Account exposing (HeadHash)
import Msg as RootMsg exposing (Msg(MsgForAuthentication, NoOp))
import Authentication.Msg exposing (Msg(CreateKeys, DoneCreateKeys, Login, DoneLogin))
import Authentication.Model exposing (Keys)


port createdKeysStream : (Maybe { hash : HeadHash, keys : Keys } -> msg) -> Sub msg


port requestCreateKeys : () -> Cmd msg


createdKeysInput : Sub RootMsg.Msg
createdKeysInput =
    createdKeysStream (Maybe.map (MsgForAuthentication << DoneCreateKeys) >> Maybe.withDefault NoOp)


port doneLoginStream : (Maybe HeadHash -> msg) -> Sub msg


port requestLogin : Keys -> Cmd msg


doneLoginInput : Sub RootMsg.Msg
doneLoginInput =
    doneLoginStream (Maybe.map (MsgForAuthentication << DoneLogin) >> Maybe.withDefault NoOp)
