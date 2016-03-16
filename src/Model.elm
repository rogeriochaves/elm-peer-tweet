module Model (Model, initialModel) where

import Effects exposing (Effects)
import Action exposing (Action)
import Router.Model as Router
import Data.Model as Data
import NewTweet.Model as NewTweet
import Publish.Model as Publish
import Download.Model as Download
import DateTime.Model as DateTime
import Search.Model as Search


type alias Model =
  { router : Router.Model
  , data : Data.Model
  , newTweet : NewTweet.Model
  , publish : Publish.Model
  , download : Download.Model
  , dateTime : DateTime.Model
  , search : Search.Model
  }


initialModel : String -> ( Model, Effects Action )
initialModel path =
  ( { router = Router.initialModel path
    , data = Data.initialModel
    , newTweet = NewTweet.initialModel
    , publish = Publish.initialModel
    , download = Download.initialModel
    , dateTime = DateTime.initialModel
    , search = Search.initialModel
    }
  , Effects.none
  )
