module Sidebar.View.Sidebar where

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Action as RootAction exposing (..)
import Model exposing (Model)
import Publish.View.PublishProgress as PublishProgress

view : Signal.Address RootAction.Action -> Model -> Html
view address model =
  div [class "flexbox-sidebar"] [
    div [class "sidebar-item ion-home top"] [],
    div [class "sidebar-item space"] [],
    PublishProgress.view address model.publish
  ]
