module Update (update) where

import Action exposing (Action)
import Model exposing (Model)
import Effects exposing (Effects)
import Router.Update as Router
import Router.Effects as RouterEffects
import Data.Update as Data
import Data.Effects as DataEffects
import NewTweet.Update as NewTweet
import Publish.Update as Publish
import Publish.Effects as PublishEffects
import Download.Update as Download
import Download.Effects as DownloadEffects
import DateTime.Update as DateTime
import Search.Update as Search


update : Signal.Address Action -> Action -> Model -> ( Model, Effects Action )
update jsAddress action model =
  ( modelUpdate action model, effectsUpdate jsAddress action model )


modelUpdate : Action -> Model -> Model
modelUpdate action model =
  { model
    | router = Router.update action model.router
    , data = Data.update action model.data
    , newTweet = NewTweet.update action model.newTweet
    , publish = Publish.update action model.publish
    , download = Download.update action model.download
    , dateTime = DateTime.update action model.dateTime
    , search = Search.update action model.search
  }


effectsUpdate : Signal.Address Action -> Action -> Model -> Effects Action
effectsUpdate jsAddress action model =
  Effects.batch
    [ RouterEffects.effects action model.router
    , DataEffects.effects jsAddress action model.data
    , PublishEffects.effects jsAddress action model.data
    , DownloadEffects.effects jsAddress action model.data
    ]
