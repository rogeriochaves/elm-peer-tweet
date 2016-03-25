module Sidebar.View.Sidebar (..) where

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Action as RootAction exposing (Action(ActionForRouter))
import Model exposing (Model)
import Publish.View.PublishProgress as PublishProgress
import Download.View.DownloadProgress as DownloadProgress
import Router.Routes exposing (Sitemap(..))
import Router.Action exposing (Action(UpdatePath))
import Router.Model exposing (Page(..))
import Timeline.View.Avatar as Avatar
import Account.Model as Account


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
view address model userAccount =
  let
    classes =
      { home = "", followList = "", search = "", settings = "" }

    activeClass =
      case model.router.page of
        Timeline ->
          { classes | home = "active" }

        FollowingList ->
          { classes | followList = "active" }

        Search ->
          { classes | search = "active" }

        Settings ->
          { classes | settings = "active" }

        _ ->
          classes
  in
    div
      [ class "sidebar" ]
      [ div
          [ class "sidebar-items blue darken-4" ]
          [ button
              [ class "sidebar-button sidebar-avatar"
              , onClick address (ActionForRouter <| UpdatePath <| ProfileRoute userAccount.head.hash)
              ]
              [ Avatar.view userAccount.head ]
          , button
              [ class <| "sidebar-button material-icons " ++ activeClass.home
              , onClick address (ActionForRouter <| UpdatePath <| TimelineRoute ())
              ]
              [ text "home" ]
          , button
              [ class <| "sidebar-button material-icons " ++ activeClass.followList
              , onClick address (ActionForRouter <| UpdatePath <| FollowingListRoute ())
              ]
              [ text "group" ]
          , button
              [ class <| "sidebar-button material-icons " ++ activeClass.search
              , onClick address (ActionForRouter <| UpdatePath <| SearchRoute ())
              ]
              [ text "search" ]
          , button
              [ class <| "sidebar-button material-icons " ++ activeClass.settings
              , onClick address (ActionForRouter <| UpdatePath <| SettingsRoute ())
              ]
              [ text "settings" ]
          , div [ class "sidebar-space" ] []
          , PublishProgress.view address model.publish
          , DownloadProgress.view address model.download
          ]
      ]
