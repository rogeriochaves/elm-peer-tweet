module Router.Effects (..) where

import Router.Action as Router exposing (Action(..))
import Router.Model exposing (Model, Page(..), routeToPage, pathToPage)
import Router.Routes exposing (Sitemap(..), match, route)
import Effects exposing (Effects)
import Task
import History
import Action as RootAction exposing (Action(..))


effects : RootAction.Action -> Model -> Effects RootAction.Action
effects action router =
  case action of
    ActionForRouter routerAction ->
      effectsRouter routerAction router

    _ ->
      Effects.none


effectsRouter : Router.Action -> Model -> Effects RootAction.Action
effectsRouter action model =
  case action of
    PathChange path ->
      Effects.none

    UpdatePath r ->
      route r
        |> History.setPath
        |> Task.toMaybe
        |> Task.map (always NoOp)
        |> Effects.task
