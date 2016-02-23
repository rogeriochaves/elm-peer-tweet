module View where

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Topbar.View.Topbar as Topbar
import Timeline.View.Timeline as Timeline

view : Html
view =
  div [class "flexbox-container"] [
    div [class "flexbox-sidebar"] [
      div [class "sidebar-item ion-home top"] [],
      div [class "sidebar-item space"] []
    ],
    div [class "flexbox-content"] [
      Topbar.view,
      Timeline.view
    ]
  ]
