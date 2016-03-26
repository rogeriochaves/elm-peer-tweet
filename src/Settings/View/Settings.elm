module Settings.View.Settings (..) where

import Html exposing (..)
import Model exposing (Model)
import Html.Attributes exposing (class, type', value, href, target)
import Html.Events exposing (on, targetValue, onClick)
import Account.Model as Account
import Topbar.View.Topbar as Topbar
import Action as RootAction exposing (Action(ActionForSettings))
import Settings.Action exposing (Action(UpdateAvatar, SaveSettings))


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
view address model userAccount =
  div
    []
    [ Topbar.view address model "Settings"
    , avatarField address model userAccount
    ]


avatarField : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
avatarField address model userAccount =
  div
    [ class "container settings" ]
    [ div
        [ class "input-field" ]
        [ input
            [ type' "text"
            , value model.settings.avatar
            , on "input" targetValue (Signal.message address << ActionForSettings << UpdateAvatar)
            ]
            []
        , label
            [ class "active" ]
            [ text "Avatar Image URL" ]
        ]
    , p
        [ class "hint" ]
        [ span [] [ text "Hint: you can use " ]
        , a [ href "http://imgur.com/", target "_blank", class "link" ] [ text "imgur.com" ]
        , span [] [ text " to upload your image and paste the direct link here" ]
        ]
    , saveButton address model userAccount
    ]


saveButton : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
saveButton address model userAccount =
  let
    buttonClass =
      "waves-effect waves-light btn btn-full blue lighten-1"
  in
    if userAccount.head.a == model.settings.avatar then
      button
        [ class <| buttonClass ++ " disabled" ]
        [ text "Settings Saved" ]
    else
      button
        [ class buttonClass, onClick address <| ActionForSettings SaveSettings ]
        [ text "Save" ]
