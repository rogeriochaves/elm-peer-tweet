module Search.View.Search (..) where

import Html exposing (..)
import Html.Attributes exposing (class, type', id, value, for, placeholder)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Download.Action exposing (Action(DownloadHead))
import Search.Action exposing (Action(Update))
import Model exposing (Model)
import Account.Model as Account exposing (Hash)
import Accounts.Model exposing (findAccount)
import Timeline.View.Profile as Profile
import Download.Model as Download exposing (isLoading, hasError, getError)
import Utils.Utils exposing (onEnter)
import Authentication.View.Login exposing (loading)


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
view address model userAccount =
  div
    []
    [ searchBar address model
    , findAccount model.accounts (Just model.search.query)
        |> Maybe.map (Profile.view address model userAccount)
        |> Maybe.withDefault (searchStatus model.download model.search.query)
    ]


searchStatus : Download.Model -> Hash -> Html
searchStatus model hash =
  if isLoading model hash then
    div [ class "search-loading" ] [ loading ]
  else if hasError model hash then
    div
      [ class "container"]
      [ p [] [ text <| Maybe.withDefault "Error" (getError model hash) ] ]
  else
    text ""


searchBar : Signal.Address RootAction.Action -> Model -> Html
searchBar address model =
  nav
    []
    [ div
      [ class "nav-wrapper blue"]
      [ div
        [ class "input-field" ]
        [ input
            [ on "input" targetValue (Signal.message address << ActionForSearch << Update)
            , type' "search"
            , id "search"
            , value model.search.query
            , onEnter address (ActionForDownload <| DownloadHead model.search.query)
            , placeholder "Search by hash..."
            ]
            []
        , label
            [ for "search" ]
            [ i [ class "material-icons" ] [ text "search" ] ]
        , i [ class "material-icons" ] [ text "close" ]
        ]
      ]
    ]
