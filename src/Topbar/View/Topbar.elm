module Topbar.View.Topbar (..) where

import Html exposing (Html, div, text, nav)
import Html.Attributes exposing (class)
import Msg exposing (Msg)
import Model exposing (Model)


view : Signal.Address Msg -> Model -> String -> Html
view address model title =
  nav
    []
    [ div
        [ class "nav-wrapper grey lighten-5 black-text" ]
        [ text title
        ]
    ]
