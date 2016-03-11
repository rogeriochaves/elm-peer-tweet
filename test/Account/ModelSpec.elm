module Account.ModelSpec where

import Account.Model exposing (Model, initialModel, nextHash, nextHashToDownload, findTweet, addTweet)
import ElmTestBDDStyle exposing (..)

setupModel : Model
setupModel =
  { initialModel |
      tweets = [{ hash = "bar", d = 1, t = "something", next = ["baz"] }
               ,{ hash = "baz", d = 1, t = "something", next = ["qux"] }]
  }

tests : Test
tests =
  describe "Account.Model"
    [ describe "nextHash"
      [ it "returns the next hash" <|
          expect (nextHash <| Just { next = [ "foo", "bar" ] }) toBe <| Just "foo"

      , it "returns empty when there are no nexts" <|
          expect (nextHash <| Just { next = [] }) toBe Nothing
      ]

    , describe "nextHashToDownload"
      [ it "returns the last not present hash" <|
          expect (nextHashToDownload setupModel "bar") toBe <| Just "qux"

      , it "returns the same hash if it is not there" <|
          expect (nextHashToDownload setupModel "uno") toBe <| Just "uno"

      , it "returns nothing if there is no next" <|
          let
            model = { setupModel | tweets = { hash = "baz", d = 1, t = "something", next = [] } :: setupModel.tweets }
          in
            expect (nextHashToDownload model "bar") toBe <| Nothing
      ]

    , describe "findTweet" <|
      [ it "finds the tweet" <|
          expect (findTweet setupModel <| Just "bar") toBe <| Just { hash = "bar", d = 1, t = "something", next = ["baz"] }

      , it "returns empty when the tweet is not there" <|
          expect (findTweet setupModel <| Just "uno") toBe Nothing
      ]

    , describe "addTweet" <|
      [ it "adds a tweet if it is not there yet" <|
          let
            tweet = { hash = "uno", d = 1, t = "something", next = [] }
          in
            expect
              (addTweet setupModel tweet |> .tweets |> List.head)
            toBe <| Just tweet

      , it "does not add an existing tweet" <|
          expect (addTweet setupModel { hash = "bar", d = 1, t = "something", next = ["baz"] }) toBe setupModel
      ]
    ]
