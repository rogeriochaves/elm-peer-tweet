module Account.UpdateSpec where

import Account.Update exposing (update)
import Account.Model exposing (initialModel)
import Action exposing (..)
import Download.Action exposing (..)
import ElmTestBDDStyle exposing (..)

tests : Test
tests =
  describe "Account.Update"
    [ describe "downloaded account"
      [ it "adds new tweets to account" <|
          let
            tweet = { hash = "foo", d = 1, t = "bar", next = [] }
            model = initialModel
            action = ActionForDownload (DoneDownloadTweet tweet)
          in
            expect (update action model) toBe { initialModel | tweets = tweet :: initialModel.tweets }
      ]
    ]
