module Topbar.View.Topbar (..) where

import Html exposing (Html, div, text, nav)
import Html.Attributes exposing (class)
import Action exposing (Action)
import Model exposing (Model)


view : Signal.Address Action -> Model -> String -> Html
view address model title =
  nav
    []
    [ div
        [ class "nav-wrapper grey lighten-5 black-text" ]
        [ text title
        ]
    ]
