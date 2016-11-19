module Topbar.View.Topbar exposing (..)

import Html exposing (Html, div, text, nav)
import Html.Attributes exposing (class)
import Msg exposing (Msg)
import Model exposing (Model)


view : Model -> String -> Html Msg
view model title =
    nav []
        [ div [ class "nav-wrapper grey lighten-5 black-text" ]
            [ text title
            ]
        ]
