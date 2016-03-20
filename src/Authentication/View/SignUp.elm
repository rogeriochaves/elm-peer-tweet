module Authentication.View.SignUp (view) where

import Html exposing (..)
import Html.Attributes exposing (class, type', value)
import Html.Events exposing (onClick, on, targetValue)
import Action as RootAction exposing (Action(ActionForAuthentication, ActionForRouter, ActionForAccounts))
import Model exposing (Model)
import Action as RootAction exposing (..)
import Router.Routes exposing (Sitemap(..))
import Router.Action exposing (Action(UpdatePath))
import Authentication.Action exposing (Action(CreateKeys, UpdateName))
import Account.Model exposing (HeadHash)
import Accounts.Action exposing (Action(CreateAccount))


break : Html
break =
  br [] []


bold : String -> Html
bold x =
  b [] [ text x ]


view : Signal.Address RootAction.Action -> Model -> Html
view address model =
  model.authentication.hash
    |> Maybe.map (createdKeys address model)
    |> Maybe.withDefault (newAccount address model)


createdKeys : Signal.Address RootAction.Action -> Model -> HeadHash -> Html
createdKeys address { dateTime, authentication } userHash =
  div
    []
    [ p
        []
        [ text "Congratulations, your account hash is:"
        , break
        , text userHash
        , break
        , text "Share this hash so people can follow you"
        ]
    , p
        []
        [ text "Here's your public and secret keys, it is like your login and password."
        , break
        , text "This will only be shown once, so save it somewhere safe, specially the secret key"
        , break
        , bold "Public Key: "
        , text authentication.keys.publicKey
        , break
        , bold "Secret Key: "
        , text authentication.keys.secretKey
        ]
    , button [ onClick address <| ActionForAccounts <| CreateAccount userHash authentication.name dateTime.timestamp ] [ text "Continue" ]
    ]


newAccount : Signal.Address RootAction.Action -> Model -> Html
newAccount address model =
  div
    []
    [ text "Do you want to create an account?"
    , div
        [ class "input-field" ]
        [ input
            [ type' "text"
            , value model.authentication.name
            , on "input" targetValue (Signal.message address << ActionForAuthentication << UpdateName)
            ]
            []
        , label
            []
            [ text "Name" ]
        ]
    , button [ onClick address <| ActionForAuthentication <| CreateKeys ] [ text "Yes" ]
    , button [ onClick address <| ActionForRouter <| UpdatePath <| TimelineRoute () ] [ text "No" ]
    ]
