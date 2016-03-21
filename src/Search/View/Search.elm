module Search.View.Search (..) where

import Html exposing (Html, div, input, text, button)
import Html.Events exposing (onClick, on, targetValue)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Download.Action exposing (Action(DownloadHead))
import Search.Action exposing (Action(Update))
import Model exposing (Model)
import Account.Model as Account exposing (Hash)
import Accounts.Model exposing (findAccount)
import Timeline.View.Timeline as Timeline
import Download.Model as Download exposing (isLoading, hasError, getError)


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
view address model account =
  div
    []
    [ searchBar address model account
    , findAccount model.accounts (Just model.search.query)
        |> Maybe.map (Timeline.view address model)
        |> Maybe.withDefault (text <| searchStatus model.download model.search.query)
    ]


searchStatus : Download.Model -> Hash -> String
searchStatus model hash =
  if isLoading model hash then
    "Searching..."
  else if hasError model hash then
    Maybe.withDefault "Error" (getError model hash)
  else
    ""


searchBar : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
searchBar address model account =
  div
    []
    [ input
        [ on "input" targetValue (Signal.message address << ActionForSearch << Update)
        ]
        [ text model.search.query
        ]
    , button
        [ onClick address (ActionForDownload <| DownloadHead model.search.query) ]
        [ text "Search"
        ]
    ]
