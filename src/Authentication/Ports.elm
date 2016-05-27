module Authentication.Ports (..) where

import Account.Model as Account exposing (HeadHash)
import Msg exposing (Msg(MsgForAuthentication, NoOp))
import Authentication.Msg exposing (Msg(CreateKeys, DoneCreateKeys, Login, DoneLogin))
import Authentication.Model exposing (Keys)
import Ports exposing (jsMailbox)
import Utils.Utils exposing (isJust, filterEmpty)


port createdKeysStream : Signal (Maybe { hash : HeadHash, keys : Keys })
port requestCreateKeys : Signal (Maybe ())
port requestCreateKeys =
  let
    getRequest msg =
      case msg of
        MsgForAuthentication CreateKeys ->
          Just ()

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


createdKeysInput : Signal Msg.Msg
createdKeysInput =
  Signal.map
    (Maybe.map (MsgForAuthentication << DoneCreateKeys) >> Maybe.withDefault NoOp)
    createdKeysStream


port doneLoginStream : Signal (Maybe HeadHash)
port requestLogin : Signal (Maybe Keys)
port requestLogin =
  let
    getRequest msg =
      case msg of
        MsgForAuthentication (Login keys) ->
          Just keys

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


doneLoginInput : Signal Msg.Msg
doneLoginInput =
  Signal.map
    (Maybe.map (MsgForAuthentication << DoneLogin) >> Maybe.withDefault NoOp)
    doneLoginStream
