module Authentication.Ports (..) where

import Account.Model as Account exposing (HeadHash)
import Action exposing (Action(ActionForAuthentication, NoOp))
import Authentication.Action exposing (Action(CreateKeys, DoneCreateKeys, Login, DoneLogin))
import Authentication.Model exposing (Keys)
import Ports exposing (jsMailbox)
import Utils exposing (isJust, filterEmpty)


port createdKeysStream : Signal (Maybe { hash : HeadHash, keys : Keys })
port requestCreateKeys : Signal (Maybe ())
port requestCreateKeys =
  let
    getRequest action =
      case action of
        ActionForAuthentication CreateKeys ->
          Just ()

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


createdKeysInput : Signal Action.Action
createdKeysInput =
  Signal.map
    (Maybe.map (ActionForAuthentication << DoneCreateKeys) >> Maybe.withDefault NoOp)
    createdKeysStream


port doneLoginStream : Signal (Maybe HeadHash)
port requestLogin : Signal (Maybe Keys)
port requestLogin =
  let
    getRequest action =
      case action of
        ActionForAuthentication (Login keys) ->
          Just keys

        _ ->
          Nothing
  in
    Signal.map getRequest jsMailbox.signal
      |> filterEmpty


doneLoginInput : Signal Action.Action
doneLoginInput =
  Signal.map
    (Maybe.map (ActionForAuthentication << DoneLogin) >> Maybe.withDefault NoOp)
    doneLoginStream
