module Sidebar.View.Sidebar (..) where

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Action as RootAction exposing (..)
import Model exposing (Model)
import Publish.View.PublishProgress as PublishProgress
import Download.View.DownloadProgress as DownloadProgress
import Router.Routes exposing (Sitemap(..))
import Router.Action exposing (Action(UpdatePath))


view : Signal.Address RootAction.Action -> Model -> Html
view address model =
  div
    [ class "flexbox-sidebar" ]
    [ div [ class "sidebar-item ion-home top", onClick address (ActionForRouter <| UpdatePath <| TimelineRoute ()) ] []
    , div [ class "sidebar-item ion-search top", onClick address (ActionForRouter <| UpdatePath <| SearchRoute ()) ] []
    , div [ class "sidebar-item space" ] []
    , PublishProgress.view address model.publish
    , DownloadProgress.view address model.download
    ]
