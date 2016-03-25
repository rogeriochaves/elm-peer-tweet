module FollowingList.View.FollowingList (..) where

import Html exposing (..)
import Html.Attributes exposing (class, type', id, value, for)
import Action as RootAction
import Model exposing (Model)
import Account.Model as Account exposing (HeadHash, followList)
import Accounts.Model exposing (findAccount)
import Topbar.View.Topbar as Topbar
import Timeline.View.Avatar as Avatar


view : Signal.Address RootAction.Action -> Model -> Account.Model -> Html
view address model userAccount =
  div
    []
    [ Topbar.view address model "Following"
    , ul [ class "collection" ] (List.map (followingItem address model userAccount) (followList userAccount))
    ]


followingItem : Signal.Address RootAction.Action -> Model -> Account.Model -> HeadHash -> Html
followingItem address model userAccount followingHash =
  let
    foundAccount =
      findAccount model.accounts (Just followingHash)
  in
    case foundAccount of
      Just account ->
        li
          [ class "collection-item" ]
          [ Avatar.view account.head
          , span [ class "title" ] [ text account.head.n ]
          , p [] [ text <| "@" ++ account.head.hash ]
          ]

      Nothing ->
        div [] []
