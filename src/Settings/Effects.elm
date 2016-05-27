module Settings.Effects (effects) where

import Msg as RootMsg exposing (Msg(MsgForSettings, MsgForAccounts, MsgForPublish))
import Model exposing (Model)
import Settings.Msg exposing (Msg(SaveSettings))
import Task
import Effects exposing (Effects)
import Accounts.Msg exposing (Msg(UpdateUserAccount))
import Accounts.Model exposing (getUserAccount)
import Task exposing (andThen)


effects : RootMsg.Msg -> Model -> Effects RootMsg.Msg
effects msg model =
  let
    updatedUser userAccount head =
      { userAccount | head = { head | a = model.settings.avatar, d = round model.dateTime.timestamp } }
  in
    case msg of
      MsgForSettings SaveSettings ->
        case getUserAccount model of
          Just userAccount ->
            Task.succeed (MsgForAccounts <| UpdateUserAccount <| updatedUser userAccount userAccount.head)
              |> Effects.task

          Nothing ->
            Effects.none

      _ ->
        Effects.none
