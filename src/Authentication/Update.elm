module Authentication.Update (update) where

import Msg as RootMsg exposing (..)
import Authentication.Msg as Authentication exposing (Msg(..))
import Authentication.Model exposing (Model)
import Accounts.Msg exposing (Msg(CreateAccount, UpdateUserAccount))


update : RootMsg.Msg -> Model -> Model
update msg model =
  case msg of
    MsgForAuthentication authenticationMsg ->
      updateAuthentication authenticationMsg model

    MsgForAccounts (UpdateUserAccount account) ->
      { model | hash = (Just account.head.hash) }

    MsgForAccounts (CreateAccount hash _ _) ->
      { model | hash = (Just hash) }

    _ ->
      model


updateAuthentication : Authentication.Msg -> Model -> Model
updateAuthentication msg model =
  let
    keys =
      model.keys
  in
    case msg of
      CreateKeys ->
        model

      DoneCreateKeys { hash, keys } ->
        { model | hash = (Just hash), keys = keys }

      UpdatePublicKey publicKey ->
        { model | keys = { keys | publicKey = publicKey } }

      UpdateSecretKey secretKey ->
        { model | keys = { keys | secretKey = secretKey } }

      UpdateName name ->
        { model | name = name }

      Login _ ->
        model

      DoneLogin hash ->
        { model | hash = (Just hash) }
