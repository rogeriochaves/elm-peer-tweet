module Account.ModelSpec exposing (..)

import Account.Model exposing (Model, initialModel, nextHash, nextHashToDownload, findItem, addTweet)
import Test exposing (..)
import Expect exposing (..)
import ElmTestBDDStyle exposing (..)


setupModel : Model
setupModel =
    { initialModel
        | tweets =
            [ { hash = "bar", d = 1, t = "something", next = [ "baz" ] }
            , { hash = "baz", d = 1, t = "something", next = [ "qux" ] }
            ]
    }


tests : Test
tests =
    describe "Account.Model"
        [ describe "nextHash"
            [ it "returns the next hash" <|
                expect (nextHash <| Just { next = [ "foo", "bar" ] }) to equal <|
                    Just "foo"
            , it "returns empty when there are no nexts" <|
                expect (nextHash <| Just { next = [] }) to equal Nothing
            ]
        , describe "nextHashToDownload"
            [ it "returns the last not present hash" <|
                expect (nextHashToDownload setupModel.tweets "bar") to equal <|
                    Just "qux"
            , it "returns the same hash if it is not there" <|
                expect (nextHashToDownload setupModel.tweets "uno") to equal <|
                    Just "uno"
            , it "returns nothing if there is no next" <|
                let
                    model =
                        { setupModel | tweets = { hash = "baz", d = 1, t = "something", next = [] } :: setupModel.tweets }
                in
                    expect (nextHashToDownload model.tweets "bar") to equal <| Nothing
            ]
        , describe "findItem" <|
            [ it "finds the tweet" <|
                expect (findItem setupModel.tweets <| Just "bar") to equal <|
                    Just { hash = "bar", d = 1, t = "something", next = [ "baz" ] }
            , it "returns empty when the tweet is not there" <|
                expect (findItem setupModel.tweets <| Just "uno") to equal Nothing
            ]
        , describe "addTweet" <|
            [ it "adds a tweet if it is not there yet" <|
                let
                    tweet =
                        { hash = "uno", d = 1, t = "something", next = [] }
                in
                    expect (addTweet setupModel tweet |> .tweets |> List.head)
                        to
                        equal
                        (Just tweet)
            , it "does not add an existing tweet" <|
                expect (addTweet setupModel { hash = "bar", d = 1, t = "something", next = [ "baz" ] }) to equal setupModel
            ]
        ]
