module Accounts.ModelSpec exposing (..)

import Accounts.Model exposing (Model, timeline)
import Account.Model as Account exposing (initialModel, Tweet, FollowBlock)
import Model as RootModel
import ElmTestBDDStyle exposing (..)
import Router.Routes exposing (Page(TimelineRoute))


someUserTweet1 : Tweet
someUserTweet1 =
    { hash = "someUserTweet1", t = "Tweet from @someUser", d = 20, next = [] }


someUserTweet2 : Tweet
someUserTweet2 =
    { hash = "someUserTweet2", t = "Another tweet from @someUser", d = 40, next = [ "someUserTweet1" ] }


someUser : Account.Model
someUser =
    let
        head =
            initialModel.head
    in
        { initialModel
            | head = { head | hash = "someUser", next = [ "someUserTweet2" ], f = [] }
            , tweets = [ someUserTweet2, someUserTweet1 ]
        }


tweet1 : Tweet
tweet1 =
    { hash = "tweet1", t = "Hello World", d = 10, next = [] }


tweet2 : Tweet
tweet2 =
    { hash = "tweet2", t = "My second tweet", d = 30, next = [ "tweet1" ] }


followBlock1 : FollowBlock
followBlock1 =
    { hash = "followBlock1", l = [ "someUser" ], next = [] }


userAccount : Account.Model
userAccount =
    let
        head =
            initialModel.head
    in
        { initialModel
            | head = { head | hash = "user", next = [ "tweet2" ], f = [ "followBlock1" ] }
            , tweets = [ tweet2, tweet1 ]
            , followBlocks = [ followBlock1 ]
        }


model : RootModel.Model
model =
    let
        initialModel =
            fst <| RootModel.initialModel { userHash = (Just "user"), accounts = Nothing } (Ok TimelineRoute)
    in
        { initialModel | accounts = [ userAccount, someUser ] }


tests : Test
tests =
    describe "Accounts.Model"
        [ describe "timeline"
            [ it "returns the tweets from the user and who it is following, ordered descending by the timestamp"
                <| let
                    expectedTimeline =
                        [ { head = someUser.head, tweet = someUserTweet2 }
                        , { head = userAccount.head, tweet = tweet2 }
                        , { head = someUser.head, tweet = someUserTweet1 }
                        , { head = userAccount.head, tweet = tweet1 }
                        ]
                   in
                    expect (timeline model.accounts userAccount) toBe expectedTimeline
            ]
        ]
