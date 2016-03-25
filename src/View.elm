module View (..) where

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
import Action exposing (Action)
import Model exposing (Model)
import Accounts.Model exposing (getUserAccount, findAccount)
import Account.Model as Account
import Router.Model exposing (Page(..))


view : Signal.Address Action -> Model -> Html
view address model =
  let
    userHash =
      model.authentication.hash

    userAccount =
      getUserAccount model
  in
    case ( userHash, userAccount ) of
      ( Just hash, Just account ) ->
        loggedInView address model account

      _ ->
        loggedOutView address model


loggedInView : Signal.Address Action -> Model -> Account.Model -> Html
loggedInView address model account =
  div
    [ class "flexbox-container" ]
    [ Sidebar.view address model account
    , div [ class "flexbox-contents" ] [ contentView address model account ]
    ]


contentView : Signal.Address Action -> Model -> Account.Model -> Html
contentView address model userAccount =
  case model.router.page of
    Timeline ->
      Timeline.view address model userAccount

    Search ->
      SearchView.view address model userAccount

    FollowingList ->
      FollowingListView.view address model userAccount

    Profile hash ->
      findAccount model.accounts (Just hash)
        |> Maybe.map (Profile.view address model userAccount)
        |> Maybe.withDefault notFound

    Settings ->
      SettingsView.view address model userAccount

    _ ->
      notFound


notFound : Html
notFound =
  div
    []
    [ text "NotFound" ]


loggedOutView : Signal.Address Action -> Model -> Html
loggedOutView address model =
  loggedOutContentView address model


loggedOutContentView : Signal.Address Action -> Model -> Html
loggedOutContentView address model =
  case model.router.page of
    CreateAccount ->
      SignUp.view address model

    _ ->
      Login.view address model
