module DateTime.Signals (..) where

import Time exposing (every, second)
import Action as RootAction exposing (..)
import DateTime.Action exposing (..)


updateDateTime : Signal RootAction.Action
updateDateTime =
  (every <| 10 * second)
    |> Signal.map (ActionForDateTime << Update)
