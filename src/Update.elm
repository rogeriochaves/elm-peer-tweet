module Update (update) where

import Action exposing (Action)
import Model exposing (Model)
import Effects exposing (Effects)
import Data.Update as Data
import NewTweet.Update as NewTweet
import Publish.Update as Publish

update : Signal.Address Action -> Action -> Model -> (Model, Effects Action)
update jsAddress action model = (modelUpdate action model, effectsUpdate jsAddress action model)

modelUpdate : Action -> Model -> Model
modelUpdate action model =
  { model |
      data = Data.update action model.data,
      newTweet = NewTweet.update action model.newTweet,
      publish = Publish.update action model.publish
  }

effectsUpdate : Signal.Address Action -> Action -> Model -> Effects Action
effectsUpdate jsAddress action model =
  Effects.batch [
    Data.effects jsAddress action model.data,
    Publish.effects jsAddress action model.data
  ]