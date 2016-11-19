module Router.Update exposing (..)

import Msg as RootMsg exposing (Msg(..))
import Router.Routes exposing (Page(TimelineRoute), toPath)
import Navigation exposing (Location)
import Model as RootModel


update : Result String Page -> RootModel.Model -> ( RootModel.Model, Cmd RootMsg.Msg )
update result model =
    case result of
        Err _ ->
            ( model, Navigation.modifyUrl (toPath model.router.page) )

        Ok page ->
            ( { model | router = { page = page } }, Cmd.none )
