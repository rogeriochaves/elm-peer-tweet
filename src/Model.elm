module Model (Model, initialModel) where

import Data.Model as Data
import NewTweet.Model as NewTweet
import Effects exposing (Effects)
import Action exposing (Action)

type alias Model =
  { data: Data.Model
  , newTweet: NewTweet.Model
  }

initialModel : (Model, Effects Action)
initialModel =
  (
   { data = Data.initialModel
   , newTweet = NewTweet.initialModel
   }
  , Effects.none
  )
