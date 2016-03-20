module Authentication.View.Login (view) where

import Html exposing (..)
import Html.Attributes exposing (value, class, type', href)
import Html.Events exposing (onClick, on, targetValue)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Model exposing (Model)
import Download.Model exposing (isLoading, hasError)
import Action as RootAction exposing (..)
import Accounts.Action exposing (..)
import Router.Routes exposing (Sitemap(..))
import Router.Action exposing (Action(UpdatePath))
import Authentication.Action exposing (Action(UpdatePublicKey, UpdateSecretKey, Login))
import Account.Model exposing (HeadHash)


view : Signal.Address RootAction.Action -> Model -> Html
view address model =
  case model.authentication.hash of
    Just userHash ->
      if isLoading model.download userHash then
        signingIn
      else if hasError model.download userHash then
        signInError address model userHash
      else
        signIn address model

    Nothing ->
      signIn address model


signingIn : Html
signingIn =
  div
    [ class "login" ]
    [ div
        [ class "valign-wrapper login-signing-in" ]
        [ div
            [ class "valign preloader-wrapper big active" ]
            [ div
                [ class "spinner-layer spinner-blue-only" ]
                [ div
                    [ class "circle-clipper left" ]
                    [ div [ class "circle" ] [] ]
                , div
                    [ class "gap-patch" ]
                    [ div [ class "circle" ] [] ]
                , div
                    [ class "circle-clipper right" ]
                    [ div [ class "circle" ] [] ]
                ]
            ]
        ]
    ]


signIn : Signal.Address RootAction.Action -> Model -> Html
signIn address model =
  div
    [ class "login" ]
    [ loginLogo
    , loginContainer address model
    ]


signInError : Signal.Address RootAction.Action -> Model -> HeadHash -> Html
signInError address model userHash =
  div
    [ class "login" ]
    [ loginLogo
    , div
      [ class "card-panel white" ]
      [ p [] [ text "We could not retrieve account data from the network for this public/secret key pairs" ]
      , p [] [ text "This means that thoses keys are invalid or your data is not longer present on the DHT network." ]
      , p [] [ text "Do you want to start a new account using those keys? "
             , span [ class "red-text" ] [ text "This means you will lose your old tweets if there were any" ]
             ]
      , button [ class "btn green", onClick address <| ActionForAccounts <| CreateAccount userHash model.dateTime.timestamp ] [ text "Ok" ]
      ]
    , loginContainer address model
    ]


loginLogo : Html
loginLogo =
  div
    [ class "login-logo" ]
    [ b [] [ text "Peer Tweet" ] ]

loginContainer : Signal.Address RootAction.Action -> Model -> Html
loginContainer address { authentication } =
  div
    [ class "login-container" ]
    [ div
        [ class "input-field" ]
        [ input
            [ type' "text"
            , value authentication.keys.publicKey
            , on "input" targetValue (Signal.message address << ActionForAuthentication << UpdatePublicKey)
            ]
            []
        , label
            []
            [ text "Public Key" ]
        ]
    , div
        [ class "input-field" ]
        [ input
            [ type' "text"
            , value authentication.keys.secretKey
            , on "input" targetValue (Signal.message address << ActionForAuthentication << UpdateSecretKey)
            ]
            []
        , label
            []
            [ text "Secret Key" ]
        ]
    , button
        [ class "waves-effect waves-light btn blue lighten-1"
        , onClick address <| ActionForAuthentication <| Login authentication.keys
        ]
        [ text "Login" ]
    , div
        [ class "no-account" ]
        [ text "Don't have an account yet? "
        , a
            [ onClick address <| ActionForRouter <| UpdatePath <| CreateAccountRoute ()
            ]
            [ text "Create Account" ]
        ]
    ]
