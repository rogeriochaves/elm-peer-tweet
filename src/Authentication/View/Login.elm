module Authentication.View.Login (view) where

import Html exposing (Html, div, input, text, button)
import Html.Events exposing (onClick)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Model exposing (Model)
import Download.Model exposing (isLoading, hasError)
import Action as RootAction exposing (..)
import Data.Action exposing (..)


view : Signal.Address RootAction.Action -> Model -> Html
view address { download, data } =
  if isLoading download data.hash then
    text "Signing in..."
  else if hasError download data.hash then
    div
      []
      [ text "We could not retrieve account data from the network, do you want to start a new account? This means you will lost your old tweets"
      , button [ onClick address <| ActionForData CreateAccount ] [ text "Ok" ]
      ]
  else
    text "You are not logged in"
