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
import Router.Model exposing (Page(Timeline))


view : Signal.Address Action -> Model -> Html
view address model =
  case model.router.page of
    Timeline ->
      Maybe.map (loggedInView address model) (getUserAccount model.data)
        |> Maybe.withDefault (loggedOutView address model)

    _ ->
      text "Another page"


loggedInView : Signal.Address Action -> Model -> Account.Model -> Html
loggedInView address model account =
  div
    [ class "flexbox-container" ]
    [ Sidebar.view address model
    , div
        [ class "flexbox-content" ]
        [ text model.data.hash
        , Topbar.view address model account
        , Timeline.view model account
        ]
    ]


loggedOutView : Signal.Address Action -> Model -> Html
loggedOutView address model =
  text "You are not logged in"
