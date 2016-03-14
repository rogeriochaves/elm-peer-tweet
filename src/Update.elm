module Update (update) where

import Action exposing (Action)
import Model exposing (Model)
import Effects exposing (Effects)
import Data.Update as Data
import Data.Effects as DataEffects
import NewTweet.Update as NewTweet
import Publish.Update as Publish
import Publish.Effects as PublishEffects
import Download.Update as Download
import Download.Effects as DownloadEffects
import DateTime.Update as DateTime


update : Signal.Address Action -> Action -> Model -> ( Model, Effects Action )
update jsAddress action model =
  ( modelUpdate action model, effectsUpdate jsAddress action model )


modelUpdate : Action -> Model -> Model
modelUpdate action model =
  { model
    | data = Data.update action model.data
    , newTweet = NewTweet.update action model.newTweet
    , publish = Publish.update action model.publish
    , download = Download.update action model.download
    , dateTime = DateTime.update action model.dateTime
  }


effectsUpdate : Signal.Address Action -> Action -> Model -> Effects Action
effectsUpdate jsAddress action model =
  Effects.batch
    [ DataEffects.effects jsAddress action model.data
    , PublishEffects.effects jsAddress action model.data
    , DownloadEffects.effects jsAddress action model.data
    ]
