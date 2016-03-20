module Authentication.Effects (effects) where

import Action as RootAction exposing (..)
import Authentication.Action exposing (Action(CreateKeys, DoneLogin))
import Task
import Effects exposing (Effects)
import Download.Action exposing (Action(DownloadHead))


effects : Signal.Address RootAction.Action -> RootAction.Action -> Effects RootAction.Action
effects jsAddress action =
  case action of
    ActionForAuthentication (DoneLogin hash) ->
      Task.succeed (ActionForDownload <| DownloadHead hash)
        |> Effects.task

    ActionForAuthentication authenticationAction ->
      Signal.send jsAddress (ActionForAuthentication authenticationAction)
        |> Task.map (always RootAction.NoOp)
        |> Effects.task

    _ ->
      Effects.none
