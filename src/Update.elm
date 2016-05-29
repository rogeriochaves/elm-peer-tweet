module Update exposing (update)

import Msg exposing (Msg)
import Model exposing (Model)
import Router.Update as Router
import Router.Cmd as RouterCmd
import Accounts.Update as Accounts
import Accounts.Cmd as AccountsCmd
import NewTweet.Update as NewTweet
import Publish.Update as Publish
import Publish.Cmd as PublishCmd
import Download.Update as Download
import Download.Cmd as DownloadCmd
import DateTime.Update as DateTime
import Search.Update as Search
import Authentication.Update as Authentication
import Authentication.Cmd as AuthenticationCmd
import Settings.Update as Settings
import Settings.Cmd as SettingsCmd


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( modelUpdate msg model, cmdsUpdate msg model )


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


cmdsUpdate : Msg -> Model -> Cmd Msg
cmdsUpdate msg model =
    Cmd.batch
        [ RouterCmd.cmds msg model.router
        , AccountsCmd.cmds msg model.accounts
        , PublishCmd.cmds msg model
        , DownloadCmd.cmds msg model
        , AuthenticationCmd.cmds msg
        , SettingsCmd.cmds msg model
        ]
