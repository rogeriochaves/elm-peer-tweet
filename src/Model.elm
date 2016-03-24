module Model (Model, initialModel) where

import Effects exposing (Effects)
import Action exposing (Action)
import Router.Model as Router
import Accounts.Model as Accounts
import NewTweet.Model as NewTweet
import Publish.Model as Publish
import Download.Model as Download
import DateTime.Model as DateTime
import Search.Model as Search
import Download.Effects as DownloadEffects
import Authentication.Model as Authentication


type alias Model =
  { router : Router.Model
  , accounts : Accounts.Model
  , newTweet : NewTweet.Model
  , publish : Publish.Model
  , download : Download.Model
  , dateTime : DateTime.Model
  , search : Search.Model
  , authentication : Authentication.Model
  }


initialModel : String -> Maybe String -> Maybe Accounts.Model -> ( Model, Effects Action )
initialModel path userHash accounts =
  let
    model =
      { router = Router.initialModel path
      , accounts = Maybe.withDefault Accounts.initialModel accounts
      , newTweet = NewTweet.initialModel
      , publish = Publish.initialModel
      , download = Download.initialModel
      , dateTime = DateTime.initialModel
      , search = Search.initialModel
      , authentication = Authentication.initialModel userHash
      }
  in
    ( model, DownloadEffects.initialEffects model.authentication )
