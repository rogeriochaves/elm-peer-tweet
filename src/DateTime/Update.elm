module DateTime.Update exposing (update)

import Msg as RootMsg exposing (..)
import DateTime.Msg exposing (..)
import DateTime.Model exposing (Model)


update : RootMsg.Msg -> Model -> Model
update msg model =
  case msg of
    MsgForDateTime (Update time) ->
      { model | timestamp = time }

    _ ->
      model
