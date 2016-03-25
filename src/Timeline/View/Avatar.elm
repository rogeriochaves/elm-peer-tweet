module Timeline.View.Avatar (..) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Account.Model exposing (Head)


view : Head -> Html
view head =
  div [ class "avatar material-icons" ] [ text "face" ]
