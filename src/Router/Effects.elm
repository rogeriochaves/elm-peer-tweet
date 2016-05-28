module Router.Effects exposing (..)

import Router.Msg as Router exposing (Msg(..))
import Router.Model exposing (Model, Page(..), routeToPage, pathToPage)
import Router.Routes exposing (Sitemap(..), match, route)
import Effects exposing (Effects)
import Task
import History
import Msg as RootMsg exposing (Msg(..))


effects : RootMsg.Msg -> Model -> Effects RootMsg.Msg
effects msg router =
  case msg of
    MsgForRouter routerMsg ->
      effectsRouter routerMsg router

    _ ->
      Effects.none


effectsRouter : Router.Msg -> Model -> Effects RootMsg.Msg
effectsRouter msg model =
  case msg of
    PathChange path ->
      Effects.none

    UpdatePath r ->
      route r
        |> History.setPath
        |> Task.toMaybe
        |> Task.map (always NoOp)
        |> Effects.task
