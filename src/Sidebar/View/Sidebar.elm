module Sidebar.View.Sidebar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Msg as RootMsg exposing (Msg(MsgForRouter))
import Model exposing (Model)
import Publish.View.PublishProgress as PublishProgress
import Download.View.DownloadProgress as DownloadProgress
import Router.Routes exposing (Sitemap(..))
import Router.Msg exposing (Msg(UpdatePath))
import Router.Model exposing (Page(..))
import Timeline.View.Avatar as Avatar
import Account.Model as Account


view : Model -> Account.Model -> Html RootMsg.Msg
view model userAccount =
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
        div [ class "sidebar" ]
            [ div [ class "sidebar-items blue darken-4" ]
                [ button
                    [ class "sidebar-button sidebar-avatar"
                    , onClick (MsgForRouter <| UpdatePath <| ProfileRoute userAccount.head.hash)
                    ]
                    [ Avatar.view userAccount.head ]
                , button
                    [ class <| "sidebar-button material-icons " ++ activeClass.home
                    , onClick (MsgForRouter <| UpdatePath <| TimelineRoute ())
                    ]
                    [ text "home" ]
                , button
                    [ class <| "sidebar-button material-icons " ++ activeClass.followList
                    , onClick (MsgForRouter <| UpdatePath <| FollowingListRoute ())
                    ]
                    [ text "group" ]
                , button
                    [ class <| "sidebar-button material-icons " ++ activeClass.search
                    , onClick (MsgForRouter <| UpdatePath <| SearchRoute ())
                    ]
                    [ text "search" ]
                , button
                    [ class <| "sidebar-button material-icons " ++ activeClass.settings
                    , onClick (MsgForRouter <| UpdatePath <| SettingsRoute ())
                    ]
                    [ text "settings" ]
                , div [ class "sidebar-space" ] []
                , PublishProgress.view model.publish
                , DownloadProgress.view model.download
                ]
            ]
