module Settings.View.Settings exposing (..)

import Html exposing (..)
import Model exposing (Model)
import Html.Attributes exposing (class, type_, value, href, target)
import Html.Events exposing (on, targetValue, onClick)
import Account.Model as Account
import Topbar.View.Topbar as Topbar
import Msg as RootMsg exposing (Msg(MsgForSettings))
import Settings.Msg exposing (Msg(UpdateAvatar, SaveSettings))
import Json.Decode as Json


view : Model -> Account.Model -> Html RootMsg.Msg
view model userAccount =
    div []
        [ Topbar.view model "Settings"
        , avatarField model userAccount
        ]


avatarField : Model -> Account.Model -> Html RootMsg.Msg
avatarField model userAccount =
    div [ class "container settings" ]
        [ div [ class "input-field" ]
            [ input
                [ type_ "text"
                , value model.settings.avatar
                , on "input" (Json.map (MsgForSettings << UpdateAvatar) targetValue)
                ]
                []
            , label [ class "active" ]
                [ text "Avatar Image URL" ]
            ]
        , p [ class "hint" ]
            [ span [] [ text "Hint: you can use " ]
            , a [ href "http://imgur.com/", target "_blank", class "link" ] [ text "imgur.com" ]
            , span [] [ text " to upload your image and paste the direct link here" ]
            ]
        , saveButton model userAccount
        ]


saveButton : Model -> Account.Model -> Html RootMsg.Msg
saveButton model userAccount =
    let
        buttonClass =
            "waves-effect waves-light btn btn-full blue lighten-1"
    in
        if userAccount.head.a == model.settings.avatar then
            button [ class <| buttonClass ++ " disabled" ]
                [ text "Settings Saved" ]
        else
            button [ class buttonClass, onClick <| MsgForSettings SaveSettings ]
                [ text "Save" ]
