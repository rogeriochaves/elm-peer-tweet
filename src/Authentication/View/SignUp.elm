module Authentication.View.SignUp (view) where

import Html exposing (Html, div, input, text, button)
import Html.Events exposing (onClick)
import Action as RootAction exposing (Action(ActionForAuthentication, ActionForRouter))
import Model exposing (Model)
import Action as RootAction exposing (..)
import Router.Routes exposing (Sitemap(..))
import Router.Action exposing (Action(UpdatePath))
import Authentication.Action exposing (Action(CreateKeys))


view : Signal.Address RootAction.Action -> Model -> Html
view address data =
  div
    []
    [ text "Do you want to create an account?"
    , button [ onClick address <| ActionForAuthentication <| CreateKeys ] [ text "Yes" ]
    , button [ onClick address <| ActionForRouter <| UpdatePath <| TimelineRoute () ] [ text "No" ]
    ]
