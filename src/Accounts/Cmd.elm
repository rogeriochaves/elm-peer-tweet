module Accounts.Cmd exposing (effects)

import Msg as RootMsg exposing (..)
import Accounts.Model exposing (Model, findAccount)
import Accounts.Msg exposing (Msg(CreateAccount, UpdateUserAccount, AddTweetRequest, AddFollowerRequest))
import Accounts.Ports exposing (requestAddTweet, requestAddFollower)


effects : RootMsg.Msg -> Model -> Cmd RootMsg.Msg
effects msg _ =
    case msg of
        MsgForAccounts (AddTweetRequest req) ->
            requestAddTweet req

        MsgForAccounts (AddFollowerRequest req) ->
            requestAddFollower req

        _ ->
            Cmd.none
