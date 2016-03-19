module Data.Effects (effects) where

import Action as RootAction exposing (..)
import Data.Model exposing (Model, findAccount)
import Data.Action exposing (Action(CreateAccount))
import Task
import Effects exposing (Effects)
import Router.Routes exposing (Sitemap(TimelineRoute))
import Router.Action exposing (Action(UpdatePath))


effects : Signal.Address RootAction.Action -> RootAction.Action -> Model -> Effects RootAction.Action
effects jsAddress action _ =
  case action of
    ActionForData (CreateAccount _ _) ->
      Task.succeed (ActionForRouter <| UpdatePath <| TimelineRoute ())
        |> Effects.task

    ActionForData dataAction ->
      Signal.send jsAddress (ActionForData dataAction)
        |> Task.map (always RootAction.NoOp)
        |> Effects.task

    _ ->
      Effects.none
