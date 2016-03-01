module Model (Model, initialModel) where

import Data.Model as Data
import NewTweet.Model as NewTweet
import Sync.Model as Sync
import Effects exposing (Effects)
import Action exposing (Action)

type alias Model =
  { data: Data.Model
  , newTweet: NewTweet.Model
  , sync: Sync.Model
  }

initialModel : (Model, Effects Action)
initialModel =
  (
   { data = Data.initialModel
   , newTweet = NewTweet.initialModel
   , sync = Sync.initialModel
   }
  , Effects.none
  )
