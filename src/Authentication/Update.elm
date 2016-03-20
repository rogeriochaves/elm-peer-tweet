module Authentication.Update (update) where

import Action as RootAction exposing (..)
import Authentication.Action as Authentication exposing (Action(..))
import Authentication.Model exposing (Model)
import Data.Action exposing (Action(CreateAccount, UpdateUserAccount))


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForAuthentication authenticationAction ->
      updateAuthentication authenticationAction model

    ActionForData (UpdateUserAccount account) ->
      { model | hash = (Just account.head.hash) }

    ActionForData (CreateAccount hash _) ->
      { model | hash = (Just hash) }

    _ ->
      model


updateAuthentication : Authentication.Action -> Model -> Model
updateAuthentication action model =
  let
    keys =
      model.keys
  in
    case action of
      CreateKeys ->
        model

      DoneCreateKeys ( hash, keys ) ->
        { model | hash = (Just hash), keys = keys }

      UpdatePublicKey publicKey ->
        { model | keys = { keys | publicKey = publicKey } }

      UpdateSecretKey secretKey ->
        { model | keys = { keys | secretKey = secretKey } }

      Login _ ->
        model

      DoneLogin hash ->
        { model | hash = (Just hash) }
