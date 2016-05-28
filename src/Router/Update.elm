module Router.Update exposing (..)

import Router.Msg as Router exposing (Msg(..))
import Router.Model exposing (Model, Page(..), routeToPage, pathToPage)
import Msg as RootMsg exposing (Msg(..))
import History


update : RootMsg.Msg -> Model -> Model
update msg model =
    case msg of
        MsgForRouter routerMsg ->
            updateRouter routerMsg model

        _ ->
            model


updateRouter : Router.Msg -> Model -> Model
updateRouter msg model =
    case msg of
        PathChange path ->
            { page = pathToPage path }

        UpdatePath route ->
            model


routeInput : Signal RootMsg.Msg
routeInput =
    Signal.map (MsgForRouter << PathChange) History.hash
