module Account.UpdateSpec exposing (..)

import Account.Update exposing (update)
import Account.Model exposing (initialModel)
import Account.Msg exposing (..)
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

                msg =
                  AddTweet tweet
               in
                expect (update msg model) toBe { initialModel | tweets = tweet :: initialModel.tweets }
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

              msg = Update nextModel
            in
              expect (update msg model) toBe nextModel
        , it "does not update the account if the head timestamp is smaller than current account" <|
            let
              initialHead =
                initialModel.head

              model =
                { initialModel | head = { initialHead | d = 10 } }

              nextModel =
                { initialModel | head = { initialHead | d = 5 } }

              msg = Update nextModel
            in
              expect (update msg model) toBe model
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

              msg = UpdateHead nextModel.head
            in
              expect (update msg model) toBe nextModel
        , it "does not update the head if the head timestamp is smaller than current account" <|
            let
              initialHead =
                initialModel.head

              model =
                { initialModel | head = { initialHead | d = 10 } }

              nextModel =
                { initialModel | head = { initialHead | d = 5 } }

              msg = UpdateHead nextModel.head
            in
              expect (update msg model) toBe model
        ]
    ]
