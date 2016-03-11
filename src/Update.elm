module Update (update) where

import Action exposing (Action)
import Model exposing (Model)
import Effects exposing (Effects)
import Account.Update as Account
import NewTweet.Update as NewTweet
import Publish.Update as Publish
import Download.Update as Download
import DateTime.Update as DateTime


update : Signal.Address Action -> Action -> Model -> ( Model, Effects Action )
update jsAddress action model =
  ( modelUpdate action model, effectsUpdate jsAddress action model )


modelUpdate : Action -> Model -> Model
modelUpdate action model =
  { model
    | account = Account.update action model.account
    , newTweet = NewTweet.update action model.newTweet
    , publish = Publish.update action model.publish
    , download = Download.update action model.download
    , dateTime = DateTime.update action model.dateTime
  }


effectsUpdate : Signal.Address Action -> Action -> Model -> Effects Action
effectsUpdate jsAddress action model =
  Effects.batch
    [ Account.effects jsAddress action model.account
    , Publish.effects jsAddress action model.account
    , Download.effects jsAddress action model.account
    ]
