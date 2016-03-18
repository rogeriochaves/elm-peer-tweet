module DateTime.Signals (..) where

import Time exposing (every, second)
import Action as RootAction exposing (..)
import DateTime.Action exposing (..)


updateDateTime : Signal RootAction.Action
updateDateTime =
  (every second)
    |> Signal.map (ActionForDateTime << Update)
