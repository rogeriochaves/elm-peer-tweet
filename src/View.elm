module View where

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Topbar.View.Topbar as Topbar
import Timeline.View.Timeline as Timeline
import Action exposing (Action)
import Model exposing (Model)

view : Signal.Address Action -> Model -> Html
view address model =
  div [class "flexbox-container"] [
    div [class "flexbox-sidebar"] [
      div [class "sidebar-item ion-home top"] [],
      div [class "sidebar-item space"] []
    ],
    div [class "flexbox-content"] [
      text model.data.head.hash,
      Topbar.view address model,
      Timeline.view
    ]
  ]
