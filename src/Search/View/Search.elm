module Search.View.Search exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, type_, id, value, for, placeholder)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Msg as RootMsg exposing (Msg(MsgForSearch, MsgForDownload, NoOp))
import Download.Msg exposing (Msg(DownloadHead))
import Search.Msg exposing (Msg(Update))
import Model exposing (Model)
import Account.Model as Account exposing (Hash)
import Accounts.Model exposing (findAccount)
import Timeline.View.Profile as Profile
import Download.Model as Download exposing (isLoading, hasError, getError)
import Utils.Utils exposing (onEnter)
import Authentication.View.Login exposing (loading)
import Json.Decode as Json


view : Model -> Account.Model -> Html RootMsg.Msg
view model userAccount =
    div []
        [ searchBar model
        , findAccount model.accounts (Just model.search.query)
            |> Maybe.map (Profile.view model userAccount)
            |> Maybe.withDefault (searchStatus model.download model.search.query)
        ]


searchStatus : Download.Model -> Hash -> Html a
searchStatus model hash =
    if isLoading model hash then
        div [ class "search-loading" ] [ loading ]
    else if hasError model hash then
        div [ class "container" ]
            [ p [] [ text <| Maybe.withDefault "Error" (getError model hash) ] ]
    else
        text ""


searchBar : Model -> Html RootMsg.Msg
searchBar model =
    nav []
        [ div [ class "nav-wrapper blue" ]
            [ div [ class "input-field" ]
                [ input
                    [ on "input" (Json.map (MsgForSearch << Update) targetValue)
                    , type_ "search"
                    , id "search"
                    , value model.search.query
                    , onEnter NoOp (MsgForDownload <| DownloadHead model.search.query)
                    , placeholder "Search by hash..."
                    ]
                    []
                , label [ for "search" ]
                    [ i [ class "material-icons" ] [ text "search" ] ]
                , i [ class "material-icons" ] [ text "close" ]
                ]
            ]
        ]
