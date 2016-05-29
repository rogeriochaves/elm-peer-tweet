module View exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Sidebar.View.Sidebar as Sidebar
import Timeline.View.Timeline as Timeline
import Search.View.Search as SearchView
import Timeline.View.Profile as Profile
import FollowingList.View.FollowingList as FollowingListView
import Authentication.View.Login as Login
import Authentication.View.SignUp as SignUp
import Settings.View.Settings as SettingsView
import Msg exposing (Msg)
import Model exposing (Model)
import Accounts.Model exposing (getUserAccount, findAccount)
import Account.Model as Account
import Router.Model exposing (Page(..))


view : Model -> Html Msg
view model =
    let
        userHash =
            model.authentication.hash

        userAccount =
            getUserAccount model
    in
        case ( userHash, userAccount ) of
            ( Just hash, Just account ) ->
                loggedInView model account

            _ ->
                loggedOutView model


loggedInView : Model -> Account.Model -> Html Msg
loggedInView model account =
    div [ class "flexbox-container" ]
        [ Sidebar.view model account
        , div [ class "flexbox-contents" ] [ contentView model account ]
        ]


contentView : Model -> Account.Model -> Html Msg
contentView model userAccount =
    case model.router.page of
        Timeline ->
            Timeline.view model userAccount

        Search ->
            SearchView.view model userAccount

        FollowingList ->
            FollowingListView.view model userAccount

        Profile hash ->
            findAccount model.accounts (Just hash)
                |> Maybe.map (Profile.view model userAccount)
                |> Maybe.withDefault notFound

        Settings ->
            SettingsView.view model userAccount

        _ ->
            notFound


notFound : Html a
notFound =
    div []
        [ text "NotFound" ]


loggedOutView : Model -> Html Msg
loggedOutView model =
    loggedOutContentView model


loggedOutContentView : Model -> Html Msg
loggedOutContentView model =
    case model.router.page of
        CreateAccount ->
            SignUp.view model

        _ ->
            Login.view model
