module Utils (..) where

import Json.Decode as Json
import Signal
import Html exposing (Attribute)
import Html.Events exposing (on, keyCode)


isJust : Maybe a -> Bool
isJust a =
  case a of
    Just _ ->
      True

    Nothing ->
      False


filterEmpty : Signal (Maybe a) -> Signal (Maybe a)
filterEmpty =
  Signal.filter isJust Nothing


onEnter : Signal.Address a -> a -> Attribute
onEnter address value =
  on
    "keydown"
    (Json.customDecoder keyCode is13)
    (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
  if code == 13 then
    Ok ()
  else
    Err "not the right key code"
