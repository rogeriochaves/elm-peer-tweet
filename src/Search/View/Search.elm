module Search.View.Search (..) where

import Html exposing (..)
import Html.Attributes exposing (class, type', id, value, for)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Download.Action exposing (Action(DownloadHead))
import Search.Action exposing (Action(Update))
import Model exposing (Model)
import Account.Model as Account exposing (Hash)
import Accounts.Model exposing (findAccount)
import Timeline.View.Profile as Profile
import Download.Model as Download exposing (isLoading, hasError, getError)
import Json.Decode as Json


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
view address model account =
  div
    []
    [ searchBar address model account
    , findAccount model.accounts (Just model.search.query)
        |> Maybe.map (Profile.view address model)
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


onEnter : Signal.Address a -> a -> Attribute
onEnter address value =
    on "keydown"
      (Json.customDecoder keyCode is13)
      (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
  if code == 13 then Ok () else Err "not the right key code"


searchBar : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
searchBar address model account =
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
            ]
            []
        , label
            [ for "search" ]
            [ i [ class "material-icons" ] [ text "search" ] ]
        , i [ class "material-icons" ] [ text "close" ]
        ]
      ]
    ]
