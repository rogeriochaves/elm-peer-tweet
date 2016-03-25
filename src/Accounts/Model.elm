module Accounts.Model (..) where

import Account.Model as Account exposing (HeadHash, Head, Tweet, followList)
import Maybe exposing (andThen)
import Authentication.Model as AuthenticationModel


type alias Model =
  List Account.Model


initialModel : Model
initialModel =
  []


findAccount : Model -> Maybe HeadHash -> Maybe Account.Model
findAccount model hash =
  let
    find hash =
      List.filter (\a -> a.head.hash == hash) model
        |> List.head
  in
    hash `andThen` find


getUserAccount : { a | authentication : AuthenticationModel.Model, accounts : Model } -> Maybe Account.Model
getUserAccount model =
  findAccount model.accounts model.authentication.hash


isFollowing : { a | authentication : AuthenticationModel.Model, accounts : Model } -> HeadHash -> Bool
isFollowing data hash =
  getUserAccount data
    |> Maybe.map (Account.isFollowing hash)
    |> Maybe.withDefault False


followingAccounts : Model -> Account.Model -> List Account.Model
followingAccounts accounts userAccount =
  followList userAccount
    |> List.filterMap (findAccount accounts << Just)


timeline : Model -> Account.Model -> List { head : Head, tweet : Tweet }
timeline accounts userAccount =
  let
    accountTweets { head, tweets } =
      List.map (\tweet -> { head = head, tweet = tweet }) tweets

    allItems =
      followingAccounts accounts userAccount
        |> List.concatMap accountTweets
        |> List.append (accountTweets userAccount)
  in
    List.sortBy (.tweet >> .d >> (*) -1) allItems
