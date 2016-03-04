module Data.UpdateSpec where

import Data.Update exposing (update)
import Data.Model exposing (initialModel)
import Action exposing (..)
import Download.Action exposing (..)
import ElmTestBDDStyle exposing (..)

tests : Test
tests =
  describe "Data.Update"
    [ describe "downloaded data"
      [ it "adds new tweets to data" <|
          let
            model = initialModel
            tweet = { hash = "foo", t = "bar", next = [] }
            action = ActionForDownload (DoneDownloadTweet tweet)
          in
            expect (update action model) toBe { initialModel | tweets = tweet :: initialModel.tweets }

      , it "fails for non-sense stuff" <|
          expect True toBe True
      ]
    ]