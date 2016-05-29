module Timeline.View.Profile exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, type', id, value, for)
import Html.Events exposing (onClick)
import Msg as RootMsg exposing (Msg(MsgForSearch, MsgForDownload, MsgForAccounts))
import Accounts.Msg exposing (Msg(AddFollowerRequest))
import Model exposing (Model)
import Account.Model as Account exposing (Hash)
import Accounts.Model exposing (isFollowing)
import Timeline.View.Feed as Feed
import Timeline.View.Avatar as Avatar


view : Model -> Account.Model -> Account.Model -> Html RootMsg.Msg
view model userAccount account =
  div
    []
    [ div
        [ class "card white profile" ]
        [ div
          [ class "card-content"]
          [ Avatar.view account.head
          , span [ class "card-title" ] [ text account.head.n ]
          , followButton model userAccount account
          , p [] [ text <| "@" ++ account.head.hash ]
          ]
        ]
    , Feed.view model account
    ]


followButton : Model -> Account.Model -> Account.Model -> Html RootMsg.Msg
followButton model userAccount account =
  if userAccount.head.hash == account.head.hash then
    div [] []
  else if isFollowing model account.head.hash then
    button [ class "btn small blue disabled secondary-content" ] [ text "Following" ]
  else
    button
      [ class "btn small blue secondary-content"
      , onClick (MsgForAccounts <| AddFollowerRequest { account = userAccount, hash = account.head.hash })
      ]
      [ text "Follow" ]
