module Search.View.Search (..) where

import Html exposing (Html, div, input, text, button)
import Html.Events exposing (onClick, on, targetValue)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Download.Action exposing (Action(DownloadHead))
import Search.Action exposing (Action(Update))
import Model exposing (Model)
import Account.Model as Account
import Data.Model exposing (findAccount)
import Timeline.View.Timeline as Timeline


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
view address model account =
  div
    []
    [ searchBar address model account
    , findAccount model.data (Just model.search.query)
        |> Maybe.map (Timeline.view model)
        |> Maybe.withDefault (text "Nothing to show")
    ]


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
