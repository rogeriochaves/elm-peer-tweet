module Timeline.View.Avatar (..) where

import Html exposing (..)
import Html.Attributes exposing (class, src)
import Account.Model exposing (Head)
import String exposing (isEmpty)


view : Head -> Html
view head =
  if isEmpty head.a then
    div [ class "avatar material-icons" ] [ text "face" ]
  else
    img [ src head.a, class "avatar material-icons" ] []
