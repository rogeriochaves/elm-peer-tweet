module Data.Action (..) where

import Account.Model as Account exposing (HeadHash)
import Account.Action as AccountAction
import Data.Model exposing (Model, getUserAccount)


type alias AddTweetRequestPayload =
  { account : Account.Model, text : String }


type alias AddFollowerRequestPayload =
  { account : Account.Model, hash : HeadHash }


type Action
  = NoOp
  | AddTweetRequest AddTweetRequestPayload
  | AddFollowerRequest AddFollowerRequestPayload
  | UpdateAccount Account.Model
  | ActionForAccount HeadHash AccountAction.Action


addTweet : Model -> String -> Action
addTweet data text =
  getUserAccount data
    |> Maybe.map (\account -> { account = account, text = text })
    |> Maybe.map AddTweetRequest
    |> Maybe.withDefault NoOp


addFollower : Model -> HeadHash -> Action
addFollower data hash =
  getUserAccount data
    |> Maybe.map (\account -> { account = account, hash = hash })
    |> Maybe.map AddFollowerRequest
    |> Maybe.withDefault NoOp
