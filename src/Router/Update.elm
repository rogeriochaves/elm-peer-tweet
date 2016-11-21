module Router.Update exposing (..)

import Msg as RootMsg exposing (Msg(..))
import Router.Msg exposing (Msg(..))
import Router.Model exposing (Model)
import Router.Routes exposing (Page(TimelineRoute), pathParser)


update : RootMsg.Msg -> Model -> Model
update msg model =
    case msg of
        MsgForRouter (UrlChange location) ->
            case pathParser location of
                Nothing ->
                    model

                Just page ->
                    { page = page }

        _ ->
            model
