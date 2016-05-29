module Router.Cmd exposing (..)

import Router.Msg as Router exposing (Msg(..))
import Router.Model exposing (Model, routeToPage, pathToPage)
import Router.Routes exposing (Sitemap(..), match, route)
import Msg as RootMsg exposing (Msg(..))
import Accounts.Msg exposing (Msg(CreateAccount))
import Navigation


cmds : RootMsg.Msg -> Model -> Cmd RootMsg.Msg
cmds msg router =
    case msg of
        MsgForRouter routerMsg ->
            cmdsRouter routerMsg router

        MsgForAccounts (CreateAccount _ _ _) ->
            cmdsRouter (UpdatePath <| TimelineRoute ()) router

        _ ->
            Cmd.none


cmdsRouter : Router.Msg -> Model -> Cmd RootMsg.Msg
cmdsRouter msg model =
    case msg of
        PathChange path ->
            Cmd.none

        UpdatePath r ->
            route r
                |> Navigation.newUrl
