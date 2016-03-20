module Authentication.View.Login (view) where

import Html exposing (Html, div, input, p, text, button)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, on, targetValue)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Model exposing (Model)
import Download.Model exposing (isLoading, hasError)
import Action as RootAction exposing (..)
import Accounts.Action exposing (..)
import Router.Routes exposing (Sitemap(..))
import Router.Action exposing (Action(UpdatePath))
import Authentication.Action exposing (Action(UpdatePublicKey, UpdateSecretKey, Login))


view : Signal.Address RootAction.Action -> Model -> Html
view address model =
  case model.authentication.hash of
    Just userHash ->
      if isLoading model.download userHash then
        text "Signing in..."
      else if hasError model.download userHash then
        div
          []
          [ text "We could not retrieve account data from the network, do you want to start a new account? This means you will lost your old tweets"
          , button [ onClick address <| ActionForAccounts <| CreateAccount userHash model.dateTime.timestamp ] [ text "Ok" ]
          ]
      else
        signIn address model

    Nothing ->
      signIn address model


signIn : Signal.Address RootAction.Action -> Model -> Html
signIn address { authentication } =
  div
    []
    [ text "Sign in"
    , p
        []
        [ text "Public Key"
        , input
            [ value authentication.keys.publicKey
            , on "input" targetValue (Signal.message address << ActionForAuthentication << UpdatePublicKey)
            ]
            []
        ]
    , p
        []
        [ text "Secret Key"
        , input
            [ value authentication.keys.secretKey
            , on "input" targetValue (Signal.message address << ActionForAuthentication << UpdateSecretKey)
            ]
            []
        ]
    , button [ onClick address <| ActionForAuthentication <| Login authentication.keys ] [ text "Login" ]
    , button [ onClick address <| ActionForRouter <| UpdatePath <| CreateAccountRoute () ] [ text "Create Account" ]
    ]
