module Timeline.View.Avatar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src)
import Account.Model exposing (Head)
import String exposing (isEmpty)


view : Head -> Html a
view head =
    if isEmpty head.a then
        div [ class "avatar material-icons" ] [ text "face" ]
    else
        img [ src head.a, class "avatar material-icons" ] []
