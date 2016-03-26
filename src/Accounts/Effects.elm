module Accounts.Effects (effects) where

import Action as RootAction exposing (..)
import Accounts.Model exposing (Model, findAccount)
import Accounts.Action exposing (Action(CreateAccount, UpdateUserAccount))
import Task
import Effects exposing (Effects)
import Router.Routes exposing (Sitemap(TimelineRoute))
import Router.Action exposing (Action(UpdatePath))
import Publish.Action exposing (Action(PublishHead))


effects : Signal.Address RootAction.Action -> RootAction.Action -> Model -> Effects RootAction.Action
effects jsAddress action _ =
  case action of
    ActionForAccounts (CreateAccount _ _ _) ->
      Task.succeed (ActionForRouter <| UpdatePath <| TimelineRoute ())
        |> Effects.task

    ActionForAccounts (UpdateUserAccount userAccount) ->
      Task.succeed (ActionForPublish <| PublishHead <| .head <| userAccount)
        |> Effects.task

    ActionForAccounts accountsAction ->
      Signal.send jsAddress (ActionForAccounts accountsAction)
        |> Task.map (always RootAction.NoOp)
        |> Effects.task

    _ ->
      Effects.none
