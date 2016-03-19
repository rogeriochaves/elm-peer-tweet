module Authentication.Effects (effects) where

import Action as RootAction exposing (..)
import Authentication.Action exposing (Action(CreateKeys))
import Task
import Effects exposing (Effects)


effects : Signal.Address RootAction.Action -> RootAction.Action -> Effects RootAction.Action
effects jsAddress action =
  case action of
    ActionForAuthentication CreateKeys ->
      Signal.send jsAddress (ActionForAuthentication CreateKeys)
        |> Task.map (always RootAction.NoOp)
        |> Effects.task

    _ ->
      Effects.none
