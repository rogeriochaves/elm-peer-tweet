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
import Download.Effects as DownloadEffects
import Authentication.Model as Authentication


type alias Model =
  { router : Router.Model
  , data : Data.Model
  , newTweet : NewTweet.Model
  , publish : Publish.Model
  , download : Download.Model
  , dateTime : DateTime.Model
  , search : Search.Model
  , authentication : Authentication.Model
  }


initialModel : String -> Maybe String -> ( Model, Effects Action )
initialModel path userHash =
  let
    model =
      { router = Router.initialModel path
      , data = Data.initialModel userHash
      , newTweet = NewTweet.initialModel
      , publish = Publish.initialModel
      , download = Download.initialModel
      , dateTime = DateTime.initialModel
      , search = Search.initialModel
      , authentication = Authentication.initialModel
      }
  in
    ( model, DownloadEffects.initialEffects model.data )
