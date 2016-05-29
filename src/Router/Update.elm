module Router.Update exposing (..)

import Router.Msg as Router exposing (Msg(..))
import Router.Model exposing (Model, routeToPage, pathToPage)
import Msg as RootMsg exposing (Msg(..))
import Accounts.Msg exposing (Msg(CreateAccount))
import Router.Routes exposing (Sitemap(TimelineRoute))
import Navigation exposing (Location)
import Model as RootModel


update : RootMsg.Msg -> Model -> Model
update msg model =
    case msg of
        MsgForRouter routerMsg ->
            updateRouter routerMsg model

        MsgForAccounts (CreateAccount _ _ _) ->
            updateRouter (UpdatePath <| TimelineRoute ()) model

        _ ->
            model


updateRouter : Router.Msg -> Model -> Model
updateRouter msg model =
    case msg of
        PathChange path ->
            { page = pathToPage path }

        UpdatePath route ->
            model


routeInput : Location -> RootModel.Model -> ( RootModel.Model, Cmd RootMsg.Msg )
routeInput location model =
    let
        updatedModel =
            { model | router = updateRouter (PathChange location.hash) model.router }
    in
        ( updatedModel, Cmd.none )
