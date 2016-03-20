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
import String


break : Html
break =
  br [] []


bold : String -> Html
bold x =
  b [] [ text x ]


view : Signal.Address RootAction.Action -> Model -> Html
view address model =
  if String.isEmpty model.authentication.keys.publicKey then
    newAccount address model
  else
    model.authentication.hash
      |> Maybe.map (createdKeys address model)
      |> Maybe.withDefault (newAccount address model)


card : String -> String -> Html
card title content =
  div
    [ class "card card-hash" ]
    [ div
        [ class "card-content" ]
        [ div [ class "card-title" ] [ text title ]
        , p [] [ text content ]
        ]
    ]


createdKeys : Signal.Address RootAction.Action -> Model -> HeadHash -> Html
createdKeys address { dateTime, authentication } userHash =
  navbarContainer Nothing
    <| div
        []
        [ p [] [ text "Account created successfully!" ]
        , card userHash "This is your hash, share this with friends so they can follow you"
        , p [] [ text "Also, here's your public and secret keys, it is like your login and password." ]
        , div
            [ class "chip chip-key" ]
            [ div [ class "chip-title" ] [ text "Public Key" ]
            , i [ class "material-icons" ] [ text "account_circle" ]
            , input [ class "chip-text", value authentication.keys.publicKey ] []
            ]
        , div
            [ class "chip chip-key" ]
            [ div [ class "chip-title" ] [ text "Secret Key" ]
            , i [ class "material-icons" ] [ text "vpn_key" ]
            , input [ class "chip-text", value authentication.keys.secretKey ] []
            ]
        , p [] [ text "This will only be shown once, so save it somewhere safe, specially the secret key." ]
        , button
            [ class "waves-effect waves-light btn btn-full blue lighten-1"
            , onClick address <| ActionForAccounts <| CreateAccount userHash authentication.name dateTime.timestamp
            ]
            [ text "Continue" ]
        ]


navbarContainer : Maybe Attribute -> Html -> Html
navbarContainer backAction content =
  let
    menuItems =
      case backAction of
        Just action ->
          ul
            [ class "left" ]
            [ li
                []
                [ a
                    [ action ]
                    [ i [ class "material-icons" ] [ text "keyboard_arrow_left" ] ]
                ]
            ]

        Nothing ->
          div [] []
  in
    div
      []
      [ div
          [ class "navbar-fixed" ]
          [ nav
              []
              [ div
                  [ class "nav-wrapper blue lighten-1" ]
                  [ span [ class "brand-logo" ] [ text "New Account" ]
                  , menuItems
                  ]
              ]
          ]
      , div
          [ class "container" ]
          [ content ]
      ]


newAccount : Signal.Address RootAction.Action -> Model -> Html
newAccount address model =
  navbarContainer (Just <| onClick address <| ActionForRouter <| UpdatePath <| TimelineRoute ())
    <| div
        []
        [ p [ class "info-credentials" ] [ text "Your credentials will be generated automatically, just pick a name" ]
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
        , button [ class "btn btn-full blue lighten-1", onClick address <| ActionForAuthentication <| CreateKeys ] [ text "Sign Up" ]
        ]
