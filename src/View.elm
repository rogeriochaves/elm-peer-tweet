module View (..) where

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Sidebar.View.Sidebar as Sidebar
import Topbar.View.Topbar as Topbar
import Timeline.View.Timeline as Timeline
import Search.View.Search as SearchView
import Authentication.View.Login as Login
import Action exposing (Action)
import Model exposing (Model)
import Data.Model exposing (getUserAccount)
import Account.Model as Account
import Router.Model exposing (Page(..))


view : Signal.Address Action -> Model -> Html
view address model =
  let userHash = model.data.hash
      userAccount = getUserAccount model.data
  in
    case (userHash, userAccount) of
      (Just hash, Just account) ->
        loggedInView address model account
      _ ->
        loggedOutView address model


loggedInView : Signal.Address Action -> Model -> Account.Model -> Html
loggedInView address model account =
  div
    [ class "flexbox-container" ]
    [ Sidebar.view address model
    , div
        [ class "flexbox-content" ]
        [ contentView address model account ]
    ]


contentView : Signal.Address Action -> Model -> Account.Model -> Html
contentView address model account =
  case model.router.page of
    Timeline ->
      div
        []
        [ text <| toString model.data.hash
        , Topbar.view address model account
        , Timeline.view model account
        ]

    Search ->
      SearchView.view address model account

    NotFound ->
      div
        []
        [ text "NotFound" ]


loggedOutView : Signal.Address Action -> Model -> Html
loggedOutView address model =
  Login.view address model
