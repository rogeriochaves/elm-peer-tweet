module Timeline.View.Profile (..) where

import Html exposing (..)
import Html.Attributes exposing (class, type', id, value, for)
import Html.Events exposing (onClick)
import Action as RootAction exposing (Action(ActionForSearch, ActionForDownload, ActionForAccounts))
import Accounts.Action exposing (Action(AddFollowerRequest))
import Model exposing (Model)
import Account.Model as Account exposing (Hash)
import Accounts.Model exposing (isFollowing)
import Timeline.View.Feed as Feed


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Account.Model -> Html
view address model userAccount account =
  div
    []
    [ div
        [ class "card white" ]
        [ div
          [ class "card-content"]
          [ i [ class "avatar material-icons circle red" ] [ text "play_arrow" ]
          , span [ class "card-title" ] [ text account.head.n ]
          , followButton address model userAccount account
          , p [] [ text <| "@" ++ account.head.hash ]
          ]
        ]
    , Feed.view address model account
    ]


followButton : Signal.Address RootAction.Action -> Model -> Account.Model -> Account.Model -> Html
followButton address model userAccount account =
  if isFollowing model account.head.hash then
    button [ class "btn small blue disabled secondary-content" ] [ text "Following" ]
  else
    button
      [ class "btn small blue secondary-content"
      , onClick address (ActionForAccounts <| AddFollowerRequest { account = userAccount, hash = account.head.hash })
      ]
      [ text "Follow" ]
