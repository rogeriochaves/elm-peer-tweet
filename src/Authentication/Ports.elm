module Authentication.Ports (..) where

import Account.Model as Account exposing (HeadHash)
import Action exposing (Action(ActionForAuthentication, NoOp))
import Authentication.Action exposing (Action(CreateKeys, DoneCreateKeys))
import Authentication.Model exposing (Keys)
import Ports exposing (jsMailbox, isJust, filterEmpty)


port createdKeysStream : Signal (Maybe ( HeadHash, Keys ))
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
