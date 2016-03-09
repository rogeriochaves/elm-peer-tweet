module Model (Model, initialModel) where

import Effects exposing (Effects)
import Action exposing (Action)
import Data.Model as Data
import NewTweet.Model as NewTweet
import Publish.Model as Publish
import Download.Model as Download
import DateTime.Model as DateTime


type alias Model =
  { data : Data.Model
  , newTweet : NewTweet.Model
  , publish : Publish.Model
  , download : Download.Model
  , dateTime : DateTime.Model
  }


initialModel : ( Model, Effects Action )
initialModel =
  ( { data = Data.initialModel
    , newTweet = NewTweet.initialModel
    , publish = Publish.initialModel
    , download = Download.initialModel
    , dateTime = DateTime.initialModel
    }
  , Effects.none
  )
