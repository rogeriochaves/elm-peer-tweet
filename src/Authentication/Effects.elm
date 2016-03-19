module Authentication.Effects (effects) where

import Action as RootAction exposing (..)
import Authentication.Model exposing (Model)
import Authentication.Action exposing (Action(CreateKeys))
import Task
import Effects exposing (Effects)


effects : Signal.Address RootAction.Action -> RootAction.Action -> Model -> Effects RootAction.Action
effects jsAddress action _ =
  case action of
    ActionForAuthentication CreateKeys ->
      Signal.send jsAddress (ActionForAuthentication CreateKeys)
        |> Task.map (always RootAction.NoOp)
        |> Effects.task

    _ ->
      Effects.none
