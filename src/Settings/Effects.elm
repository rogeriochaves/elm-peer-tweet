module Settings.Effects (effects) where

import Action as RootAction exposing (Action(ActionForSettings, ActionForAccounts, ActionForPublish))
import Model exposing (Model)
import Settings.Action exposing (Action(SaveSettings))
import Task
import Effects exposing (Effects)
import Accounts.Action exposing (Action(UpdateUserAccount))
import Accounts.Model exposing (getUserAccount)
import Task exposing (andThen)
import Publish.Action exposing (Action(PublishHead))


effects : RootAction.Action -> Model -> Effects RootAction.Action
effects action model =
  let
    updatedUser userAccount head =
      { userAccount | head = { head | a = model.settings.avatar, d = round model.dateTime.timestamp } }
  in
    case action of
      ActionForSettings SaveSettings ->
        case getUserAccount model of
          Just userAccount ->
            Effects.batch
              [ Effects.task <| Task.succeed (ActionForAccounts <| UpdateUserAccount <| updatedUser userAccount userAccount.head)
              , Effects.task <| Task.succeed (ActionForPublish <| PublishHead <| .head <| updatedUser userAccount userAccount.head)
              ]

          Nothing ->
            Effects.none

      _ ->
        Effects.none
