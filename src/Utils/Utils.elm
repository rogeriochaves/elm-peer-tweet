module Utils.Utils exposing (..)

import Json.Decode as Json
import Html exposing (Attribute)
import Html.Events exposing (on, keyCode)
import Task exposing (perform, succeed)


isJust : Maybe a -> Bool
isJust a =
    case a of
        Just _ ->
            True

        Nothing ->
            False


onEnter : msg -> msg -> Attribute msg
onEnter fail success =
    on "keyup" <| Json.map (is13 fail success) keyCode


is13 : msg -> msg -> Int -> msg
is13 fail success code =
    if code == 13 then
        success
    else
        fail


nextMsg : msg -> Cmd msg
nextMsg msg =
    perform identity identity (succeed msg)
