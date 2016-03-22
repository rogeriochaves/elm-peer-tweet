module Timeline.View.Profile (..) where

import Html exposing (..)
import Html.Attributes exposing (class, type', id, value, for)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload))
import Model exposing (Model)
import Account.Model as Account exposing (Hash)
import Timeline.View.Feed as Feed


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
view address model account =
  div
    []
    [ div
        [ class "card white" ]
        [ div
          [ class "card-content"]
          [ i [ class "avatar material-icons circle red" ] [ text "play_arrow" ]
          , span [ class "card-title" ] [ text account.head.n ]
          , button [ class "btn blue secondary-content follow-button" ] [ text "Follow" ]
          , p [] [ text <| "@" ++ account.head.hash ]
          ]
        ]
    , Feed.view address model account
    ]
