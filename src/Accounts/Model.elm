module Accounts.Model (..) where

import Account.Model as Account
import Maybe exposing (andThen)
import Authentication.Model as AuthenticationModel


type alias Model =
  List Account.Model


initialModel : Maybe String -> Model
initialModel userHash =
  []


findAccount : Model -> Maybe Account.HeadHash -> Maybe Account.Model
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
