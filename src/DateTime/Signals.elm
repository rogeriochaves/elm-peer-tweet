module DateTime.Signals exposing (..)

import Time exposing (every, second)
import Msg as RootMsg exposing (..)
import DateTime.Msg exposing (..)


updateDateTime : Signal RootMsg.Msg
updateDateTime =
  (every second)
    |> Signal.map (MsgForDateTime << Update)
