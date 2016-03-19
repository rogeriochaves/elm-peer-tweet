module Authentication.View.Login (view) where

import Html exposing (Html, div, input, text, button)
import Html.Events exposing (onClick)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Model exposing (Model)
import Download.Model exposing (isLoading, hasError)
import Action as RootAction exposing (..)
import Data.Action exposing (..)
import Router.Routes exposing (Sitemap(..))
import Router.Action exposing (Action(UpdatePath))


view : Signal.Address RootAction.Action -> Model -> Html
view address { download, data, dateTime } =
  case data.hash of
    Just userHash ->
      if isLoading download userHash then
        text "Signing in..."
      else if hasError download userHash then
        div
          []
          [ text "We could not retrieve account data from the network, do you want to start a new account? This means you will lost your old tweets"
          , button [ onClick address <| ActionForData <| CreateAccount dateTime.timestamp ] [ text "Ok" ]
          ]
      else
        text "Sign in"

    Nothing ->
      div
        []
        [ text "You are not logged in"
        , button [ onClick address <| ActionForRouter <| UpdatePath <| CreateAccountRoute () ] [ text "Create Account" ]
        ]
