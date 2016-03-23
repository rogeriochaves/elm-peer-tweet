module Sidebar.View.Sidebar (..) where

import Html exposing (..)
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
    [ class "sidebar" ]
    [ div
      [ class "sidebar-items blue darken-4" ]
      [ button [ class "sidebar-button material-icons", onClick address (ActionForRouter <| UpdatePath <| TimelineRoute ()) ] [ text "home" ]
      , button [ class "sidebar-button material-icons", onClick address (ActionForRouter <| UpdatePath <| SearchRoute ()) ] [ text "search" ]
      , button [ class "sidebar-button material-icons", onClick address (ActionForRouter <| UpdatePath <| FollowingListRoute ()) ] [ text "group" ]
      , div [ class "sidebar-space" ] []
      , PublishProgress.view address model.publish
      , DownloadProgress.view address model.download
      ]
    ]
