module Data.Effects (effects) where

import Action as RootAction exposing (..)
import Data.Model exposing (Model, findAccount)
import Task
import Effects exposing (Effects)


effects : Signal.Address RootAction.Action -> RootAction.Action -> Model -> Effects RootAction.Action
effects jsAddress action _ =
  case action of
    ActionForData dataAction ->
      Signal.send jsAddress (ActionForData dataAction)
        |> Task.map (always RootAction.NoOp)
        |> Effects.task

    _ ->
      Effects.none
