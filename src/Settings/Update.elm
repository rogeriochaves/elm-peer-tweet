module Settings.Update (update) where

import Action as RootAction exposing (..)
import Settings.Action exposing (..)
import Settings.Model exposing (Model)
import Accounts.Action exposing (Action(UpdateUserAccount))

update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForSettings (UpdateAvatar avatar) ->
      { model | avatar = avatar }

    ActionForAccounts (UpdateUserAccount account) ->
      { model | avatar = account.head.a }

    _ ->
      model
