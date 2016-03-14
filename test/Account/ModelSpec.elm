module Account.ModelSpec where

import Account.Model exposing (Model, initialModel, nextHash, nextItemToDownload, findItem, addTweet)
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

    , describe "nextItemToDownload"
      [ it "returns the last not present hash" <|
          expect (nextItemToDownload setupModel.tweets "bar") toBe <| Just "qux"

      , it "returns the same hash if it is not there" <|
          expect (nextItemToDownload setupModel.tweets "uno") toBe <| Just "uno"

      , it "returns nothing if there is no next" <|
          let
            model = { setupModel | tweets = { hash = "baz", d = 1, t = "something", next = [] } :: setupModel.tweets }
          in
            expect (nextItemToDownload model.tweets "bar") toBe <| Nothing
      ]

    , describe "findItem" <|
      [ it "finds the tweet" <|
          expect (findItem setupModel.tweets <| Just "bar") toBe <| Just { hash = "bar", d = 1, t = "something", next = ["baz"] }

      , it "returns empty when the tweet is not there" <|
          expect (findItem setupModel.tweets <| Just "uno") toBe Nothing
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
