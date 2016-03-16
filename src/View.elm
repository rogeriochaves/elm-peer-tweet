module View (..) where

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Sidebar.View.Sidebar as Sidebar
import Topbar.View.Topbar as Topbar
import Timeline.View.Timeline as Timeline
import Action exposing (Action)
import Model exposing (Model)
import Data.Model exposing (getUserAccount)
import Account.Model as Account
import Router.Model exposing (Page(..))


view : Signal.Address Action -> Model -> Html
view address model =
  Maybe.map (loggedInView address model) (getUserAccount model.data)
    |> Maybe.withDefault (loggedOutView address model)


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
        [ text model.data.hash
        , Topbar.view address model account
        , Timeline.view model account
        ]

    Search ->
      div
        []
        [ text "Search" ]

    NotFound ->
      div
        []
        [ text "NotFound" ]


loggedOutView : Signal.Address Action -> Model -> Html
loggedOutView address model =
  text "You are not logged in"
