module FollowingList.View.FollowingList (..) where

import Html exposing (..)
import Html.Attributes exposing (class, type', id, value, for)
import Msg as RootMsg
import Model exposing (Model)
import Account.Model as Account exposing (HeadHash, followList)
import Accounts.Model exposing (findAccount)
import Topbar.View.Topbar as Topbar
import Timeline.View.Avatar as Avatar


view : Signal.Address RootMsg.Msg -> Model -> Account.Model -> Html
view address model userAccount =
  let
    following =
      followList userAccount
  in
    div
      []
      [ Topbar.view address model "Following"
      , if List.length following == 0 then
          div
            [ class "container" ]
            [ p [] [ text "You are not following anybody, use the search to find more people" ] ]
        else
          ul [ class "collection" ] (List.map (followingItem address model userAccount) following)
      ]


followingItem : Signal.Address RootMsg.Msg -> Model -> Account.Model -> HeadHash -> Html
followingItem address model userAccount followingHash =
  let
    foundAccount =
      findAccount model.accounts (Just followingHash)
  in
    case foundAccount of
      Just account ->
        li
          [ class "collection-item profile" ]
          [ Avatar.view account.head
          , span [ class "card-title" ] [ text account.head.n ]
          , p [] [ text <| "@" ++ account.head.hash ]
          ]

      Nothing ->
        div [] []
