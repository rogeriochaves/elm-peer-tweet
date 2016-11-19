module Sidebar.View.Sidebar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Msg as RootMsg exposing (Msg(MsgForRouter))
import Model exposing (Model)
import Publish.View.PublishProgress as PublishProgress
import Download.View.DownloadProgress as DownloadProgress
import Router.Routes exposing (Page(..))
import Router.Msg exposing (Msg(Go))
import Timeline.View.Avatar as Avatar
import Account.Model as Account


view : Model -> Account.Model -> Html RootMsg.Msg
view model userAccount =
    let
        classes =
            { home = "", followList = "", search = "", settings = "" }

        activeClass =
            case model.router.page of
                TimelineRoute ->
                    { classes | home = "active" }

                FollowingListRoute ->
                    { classes | followList = "active" }

                SearchRoute ->
                    { classes | search = "active" }

                SettingsRoute ->
                    { classes | settings = "active" }

                _ ->
                    classes
    in
        div [ class "sidebar" ]
            [ div [ class "sidebar-items blue darken-4" ]
                [ button
                    [ class "sidebar-button sidebar-avatar"
                    , onClick (MsgForRouter <| Go <| ProfileRoute userAccount.head.hash)
                    ]
                    [ Avatar.view userAccount.head ]
                , button
                    [ class <| "sidebar-button material-icons " ++ activeClass.home
                    , onClick (MsgForRouter <| Go TimelineRoute)
                    ]
                    [ text "home" ]
                , button
                    [ class <| "sidebar-button material-icons " ++ activeClass.followList
                    , onClick (MsgForRouter <| Go FollowingListRoute)
                    ]
                    [ text "group" ]
                , button
                    [ class <| "sidebar-button material-icons " ++ activeClass.search
                    , onClick (MsgForRouter <| Go SearchRoute)
                    ]
                    [ text "search" ]
                , button
                    [ class <| "sidebar-button material-icons " ++ activeClass.settings
                    , onClick (MsgForRouter <| Go SettingsRoute)
                    ]
                    [ text "settings" ]
                , div [ class "sidebar-space" ] []
                , PublishProgress.view model.publish
                , DownloadProgress.view model.download
                ]
            ]
