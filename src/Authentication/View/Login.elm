module Authentication.View.Login (view) where

import Html exposing (Html, div, input, text, button)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Model exposing (Model)
import Download.Model exposing (isLoading)


view : Signal.Address RootAction.Action -> Model -> Html
view address { download, data } =
  if isLoading download data.hash then
    text "Signing in..."
  else
    text "You are not logged in"
