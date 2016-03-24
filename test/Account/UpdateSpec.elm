module Account.UpdateSpec (..) where

import Account.Update exposing (update)
import Account.Model exposing (initialModel)
import Account.Action exposing (..)
import ElmTestBDDStyle exposing (..)


tests : Test
tests =
  describe
    "Account.Update"
    [ describe
        "downloaded account"
        [ it "adds new tweets to account"
            <| let
                tweet =
                  { hash = "foo", d = 1, t = "bar", next = [] }

                model =
                  initialModel

                action =
                  AddTweet tweet
               in
                expect (update action model) toBe { initialModel | tweets = tweet :: initialModel.tweets }
        ]
    , describe
        "account update"
        [ it "updates the account if the head timestamp is greater than current account" <|
            let
              initialHead =
                initialModel.head

              model =
                { initialModel | head = { initialHead | d = 10 } }

              nextModel =
                { initialModel | head = { initialHead | d = 20 } }

              action = Update nextModel
            in
              expect (update action model) toBe nextModel
        , it "does not update the account if the head timestamp is smaller than current account" <|
            let
              initialHead =
                initialModel.head

              model =
                { initialModel | head = { initialHead | d = 10 } }

              nextModel =
                { initialModel | head = { initialHead | d = 5 } }

              action = Update nextModel
            in
              expect (update action model) toBe model
        ]
    , describe
        "head update"
        [ it "updates the head if the head timestamp is greater than current account" <|
            let
              initialHead =
                initialModel.head

              model =
                { initialModel | head = { initialHead | d = 10 } }

              nextModel =
                { initialModel | head = { initialHead | d = 20 } }

              action = UpdateHead nextModel.head
            in
              expect (update action model) toBe nextModel
        , it "does not update the head if the head timestamp is smaller than current account" <|
            let
              initialHead =
                initialModel.head

              model =
                { initialModel | head = { initialHead | d = 10 } }

              nextModel =
                { initialModel | head = { initialHead | d = 5 } }

              action = UpdateHead nextModel.head
            in
              expect (update action model) toBe model
        ]
    ]
