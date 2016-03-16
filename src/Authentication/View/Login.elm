module Authentication.View.Login (view) where

import Html exposing (Html, div, input, text, button)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Model exposing (Model)


view : Signal.Address RootAction.Action -> Model -> Html
view address model =
  text "You are not logged in"
