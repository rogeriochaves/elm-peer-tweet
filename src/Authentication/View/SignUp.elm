module Authentication.View.SignUp exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, type', value)
import Html.Events exposing (onClick, on, targetValue)
import Msg as RootMsg exposing (Msg(MsgForAuthentication, MsgForRouter, MsgForAccounts))
import Model exposing (Model)
import Msg as RootMsg exposing (..)
import Router.Routes exposing (Sitemap(..))
import Router.Msg exposing (Msg(UpdatePath))
import Authentication.Msg exposing (Msg(CreateKeys, UpdateName))
import Account.Model exposing (HeadHash)
import Accounts.Msg exposing (Msg(CreateAccount))
import String


break : Html
break =
  br [] []


bold : String -> Html
bold x =
  b [] [ text x ]


view : Signal.Address RootMsg.Msg -> Model -> Html
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


createdKeys : Signal.Address RootMsg.Msg -> Model -> HeadHash -> Html
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
            , onClick address <| MsgForAccounts <| CreateAccount userHash authentication.name dateTime.timestamp
            ]
            [ text "Continue" ]
        ]


navbarContainer : Maybe Attribute -> Html -> Html
navbarContainer backMsg content =
  let
    menuItems =
      case backMsg of
        Just msg ->
          ul
            [ class "left" ]
            [ li
                []
                [ a
                    [ msg ]
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


newAccount : Signal.Address RootMsg.Msg -> Model -> Html
newAccount address model =
  navbarContainer (Just <| onClick address <| MsgForRouter <| UpdatePath <| TimelineRoute ())
    <| div
        []
        [ p [ class "info-credentials" ] [ text "Your credentials will be generated automatically, just pick a name" ]
        , div
            [ class "input-field" ]
            [ input
                [ type' "text"
                , value model.authentication.name
                , on "input" targetValue (Signal.message address << MsgForAuthentication << UpdateName)
                ]
                []
            , label
                []
                [ text "Name" ]
            ]
        , button [ class "btn btn-full blue lighten-1", onClick address <| MsgForAuthentication <| CreateKeys ] [ text "Sign Up" ]
        ]
