module Authentication.View.SignUp (view) where

import Html exposing (Html, div, p, br, b, input, text, button)
import Html.Events exposing (onClick)
import Action as RootAction exposing (Action(ActionForAuthentication, ActionForRouter, ActionForData))
import Model exposing (Model)
import Action as RootAction exposing (..)
import Router.Routes exposing (Sitemap(..))
import Router.Action exposing (Action(UpdatePath))
import Authentication.Action exposing (Action(CreateKeys))
import Authentication.Model exposing (Keys)
import Account.Model exposing (HeadHash)
import Data.Action exposing (Action(CreateAccount))


break : Html
break =
  br [] []


bold : String -> Html
bold x =
  b [] [ text x ]


view : Signal.Address RootAction.Action -> Model -> Html
view address data =
  case data.authentication.keys of
    Just keys ->
      data.authentication.hash
        |> Maybe.map (createdKeys address data keys)
        |> Maybe.withDefault (newAccount address data)

    Nothing ->
      newAccount address data


createdKeys : Signal.Address RootAction.Action -> Model -> Keys -> HeadHash -> Html
createdKeys address { dateTime } keys userHash =
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
        , text keys.publicKey
        , break
        , bold "Secret Key: "
        , text keys.secretKey
        ]
    , button [ onClick address <| ActionForData <| CreateAccount userHash dateTime.timestamp ] [ text "Continue" ]
    ]


newAccount : Signal.Address RootAction.Action -> Model -> Html
newAccount address data =
  div
    []
    [ text "Do you want to create an account?"
    , button [ onClick address <| ActionForAuthentication <| CreateKeys ] [ text "Yes" ]
    , button [ onClick address <| ActionForRouter <| UpdatePath <| TimelineRoute () ] [ text "No" ]
    ]
