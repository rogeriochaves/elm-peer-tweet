module Router.Cmd exposing (..)

import Router.Msg as Router exposing (Msg(..))
import Router.Model exposing (Model, Page(..), routeToPage, pathToPage)
import Router.Routes exposing (Sitemap(..), match, route)
import Task
import History
import Msg as RootMsg exposing (Msg(..))


effects : RootMsg.Msg -> Model -> Cmd RootMsg.Msg
effects msg router =
    case msg of
        MsgForRouter routerMsg ->
            effectsRouter routerMsg router

        MsgForAccounts (CreateAccount _ _ _) ->
            effectsRouter <| UpdatePath <| TimelineRoute ()

        _ ->
            Cmd.none


effectsRouter : Router.Msg -> Model -> Cmd RootMsg.Msg
effectsRouter msg model =
    case msg of
        PathChange path ->
            Cmd.none

        UpdatePath r ->
            route r
                |> History.setPath
                |> Task.toMaybe
                |> Task.map (always NoOp)
                |> Cmd.task
