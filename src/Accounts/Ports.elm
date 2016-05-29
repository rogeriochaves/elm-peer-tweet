port module Accounts.Ports exposing (..)

import Account.Model as Account
import Accounts.Msg exposing (..)


port accountStream : (Maybe Account.Model -> msg) -> Sub msg


port requestAddTweet : AddTweetRequestPayload -> Cmd msg


port requestAddFollower : AddFollowerRequestPayload -> Cmd msg
