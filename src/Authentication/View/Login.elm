module Authentication.View.Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, class, type', href)
import Html.Events exposing (onClick, on, targetValue)
import Msg as RootMsg exposing (Msg(MsgForSearch, MsgForDownload))
import Model exposing (Model)
import Download.Model exposing (isLoading, hasError)
import Msg as RootMsg exposing (..)
import Accounts.Msg exposing (..)
import Router.Routes exposing (Sitemap(..))
import Router.Msg exposing (Msg(UpdatePath))
import Authentication.Msg exposing (Msg(UpdatePublicKey, UpdateSecretKey, Login))
import Account.Model exposing (HeadHash)
import Json.Decode as Json


view : Model -> Html RootMsg.Msg
view model =
    let
        content =
            case model.authentication.hash of
                Just userHash ->
                    if isLoading model.download userHash then
                        loading
                    else if hasError model.download userHash then
                        signInError model userHash
                    else
                        signIn model

                Nothing ->
                    signIn model
    in
        div [ class "container" ]
            [ content ]


loading : Html a
loading =
    div [ class "login" ]
        [ div [ class "valign-wrapper login-signing-in" ]
            [ div [ class "valign preloader-wrapper big active" ]
                [ div [ class "spinner-layer spinner-blue-only" ]
                    [ div [ class "circle-clipper left" ]
                        [ div [ class "circle" ] [] ]
                    , div [ class "gap-patch" ]
                        [ div [ class "circle" ] [] ]
                    , div [ class "circle-clipper right" ]
                        [ div [ class "circle" ] [] ]
                    ]
                ]
            ]
        ]


signIn : Model -> Html RootMsg.Msg
signIn model =
    div [ class "login" ]
        [ loginLogo
        , loginContainer model
        ]


signInError : Model -> HeadHash -> Html RootMsg.Msg
signInError model userHash =
    div [ class "login" ]
        [ loginLogo
        , div [ class "card-panel white" ]
            [ p [] [ text "We could not retrieve account data from the network for this public/secret key pairs" ]
            , p [] [ text "This means that thoses keys are invalid or your data is not longer present on the DHT network." ]
            , p []
                [ text "Do you want to start a new account using those keys? "
                , span [ class "red-text" ] [ text "This means you will lose your old tweets if there were any" ]
                ]
            , button [ class "btn green", onClick <| MsgForAccounts <| CreateAccount userHash "Unknown" model.dateTime.timestamp ] [ text "Ok" ]
            ]
        , loginContainer model
        ]


loginLogo : Html a
loginLogo =
    div [ class "login-logo" ]
        [ b [] [ text "Peer Tweet" ] ]


loginContainer : Model -> Html RootMsg.Msg
loginContainer { authentication } =
    div [ class "login-container" ]
        [ div [ class "input-field" ]
            [ input
                [ type' "text"
                , value authentication.keys.publicKey
                , on "input" (Json.map (MsgForAuthentication << UpdatePublicKey) targetValue)
                ]
                []
            , label []
                [ text "Public Key" ]
            ]
        , div [ class "input-field" ]
            [ input
                [ type' "text"
                , value authentication.keys.secretKey
                , on "input" (Json.map (MsgForAuthentication << UpdateSecretKey) targetValue)
                ]
                []
            , label []
                [ text "Secret Key" ]
            ]
        , button
            [ class "waves-effect waves-light btn btn-full blue lighten-1"
            , onClick <| MsgForAuthentication <| Login authentication.keys
            ]
            [ text "Login" ]
        , div [ class "no-account" ]
            [ text "Don't have an account yet? "
            , a
                [ class "link"
                , onClick <| MsgForRouter <| UpdatePath <| CreateAccountRoute ()
                ]
                [ text "Create Account" ]
            ]
        ]
