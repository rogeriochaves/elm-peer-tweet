module Model exposing (Model, initialModel)

import Msg exposing (Msg)
import Router.Model as Router
import Accounts.Model as Accounts exposing (getUserAccount)
import NewTweet.Model as NewTweet
import Publish.Model as Publish
import Download.Model as Download
import DateTime.Model as DateTime
import Search.Model as Search
import Download.Cmd as DownloadCmd
import Authentication.Model as Authentication
import Settings.Model as Settings


type alias Model =
    { router : Router.Model
    , accounts : Accounts.Model
    , newTweet : NewTweet.Model
    , publish : Publish.Model
    , download : Download.Model
    , dateTime : DateTime.Model
    , search : Search.Model
    , authentication : Authentication.Model
    , settings : Settings.Model
    }


initialModel : String -> Maybe String -> Maybe Accounts.Model -> ( Model, Cmd Msg )
initialModel path userHash accounts =
    let
        modelAccounts =
            Maybe.withDefault Accounts.initialModel accounts

        authentication =
            Authentication.initialModel userHash

        model =
            { router = Router.initialModel path
            , accounts = modelAccounts
            , newTweet = NewTweet.initialModel
            , publish = Publish.initialModel
            , download = Download.initialModel
            , dateTime = DateTime.initialModel
            , search = Search.initialModel
            , authentication = authentication
            , settings = Settings.initialModel <| getUserAccount { authentication = authentication, accounts = modelAccounts }
            }
    in
        ( model, DownloadCmd.initialCmd model.authentication )
