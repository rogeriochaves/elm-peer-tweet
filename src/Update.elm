module Update (update) where

import Action exposing (Action)
import Model exposing (Model)
import Effects exposing (Effects)
import Data.Update as Data

update : Action -> Model -> (Model, Effects a)
update action model =
  ({ model |
      data = Data.update action model.data,
      newTweet = model.newTweet
   }
  , Effects.none)
