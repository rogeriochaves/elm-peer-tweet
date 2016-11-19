module Search.Update exposing (update)

import Msg as RootMsg exposing (..)
import Search.Msg exposing (..)
import Search.Model exposing (Model)


update : RootMsg.Msg -> Model -> Model
update msg model =
    case msg of
        MsgForSearch (Update query) ->
            { model | query = query }

        _ ->
            model
