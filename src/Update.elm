module Update exposing (update)

import Msg exposing (Msg)
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
import Settings.Update as Settings
import Settings.Effects as SettingsEffects


update : Signal.Address Msg -> Msg -> Model -> ( Model, Effects Msg )
update jsAddress msg model =
  ( modelUpdate msg model, effectsUpdate jsAddress msg model )


modelUpdate : Msg -> Model -> Model
modelUpdate msg model =
  { model
    | router = Router.update msg model.router
    , accounts = Accounts.update msg model.accounts
    , newTweet = NewTweet.update msg model.newTweet
    , publish = Publish.update msg model.publish
    , download = Download.update msg model.download
    , dateTime = DateTime.update msg model.dateTime
    , search = Search.update msg model.search
    , authentication = Authentication.update msg model.authentication
    , settings = Settings.update msg model.settings
  }


effectsUpdate : Signal.Address Msg -> Msg -> Model -> Effects Msg
effectsUpdate jsAddress msg model =
  Effects.batch
    [ RouterEffects.effects msg model.router
    , AccountsEffects.effects jsAddress msg model.accounts
    , PublishEffects.effects jsAddress msg model
    , DownloadEffects.effects jsAddress msg model
    , AuthenticationEffects.effects jsAddress msg
    , SettingsEffects.effects msg model
    ]
