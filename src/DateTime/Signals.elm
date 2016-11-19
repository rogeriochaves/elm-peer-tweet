module DateTime.Signals exposing (..)

import Time exposing (every, second)
import Msg as RootMsg exposing (..)
import DateTime.Msg exposing (..)


updateDateTime : Sub RootMsg.Msg
updateDateTime =
    (MsgForDateTime << Update)
        |> every second
