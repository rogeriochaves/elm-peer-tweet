module Update (update) where

import Action exposing (Action)
import Model exposing (Model)
import Effects exposing (Effects)
import Router.Update as Router
import Router.Effects as RouterEffects
import Accounts.Update as Accounts
import Accounts.Effects as AccountsEffects
import NewTweet.Update as NewTweet
import Publish.Update as Publish
import Publish.Effects as PublishEffects
import Download.Update as Download
import Download.Effects as DownloadEffects
import DateTime.Update as DateTime
import Search.Update as Search
import Authentication.Update as Authentication
import Authentication.Effects as AuthenticationEffects


update : Signal.Address Action -> Action -> Model -> ( Model, Effects Action )
update jsAddress action model =
  ( modelUpdate action model, effectsUpdate jsAddress action model )


modelUpdate : Action -> Model -> Model
modelUpdate action model =
  { model
    | router = Router.update action model.router
    , accounts = Accounts.update action model.accounts
    , newTweet = NewTweet.update action model.newTweet
    , publish = Publish.update action model.publish
    , download = Download.update action model.download
    , dateTime = DateTime.update action model.dateTime
    , search = Search.update action model.search
    , authentication = Authentication.update action model.authentication
  }


effectsUpdate : Signal.Address Action -> Action -> Model -> Effects Action
effectsUpdate jsAddress action model =
  Effects.batch
    [ RouterEffects.effects action model.router
    , AccountsEffects.effects jsAddress action model.accounts
    , PublishEffects.effects jsAddress action model
    , DownloadEffects.effects jsAddress action model
    , AuthenticationEffects.effects jsAddress action
    ]
