module Router.Routes exposing (..)

import Account.Model exposing (HeadHash)
import String
import UrlParser exposing (Parser, (</>), format, oneOf, s, string)
import Navigation


type Page
    = TimelineRoute
    | SearchRoute
    | CreateAccountRoute
    | FollowingListRoute
    | ProfileRoute HeadHash
    | SettingsRoute


pageParser : Parser (Page -> a) a
pageParser =
    oneOf
        [ format TimelineRoute (static "")
        , format SearchRoute (static "search")
        , format CreateAccountRoute (static "account" </> static "create")
        , format FollowingListRoute (static "following")
        , format ProfileRoute (static "profile" </> string)
        , format FollowingListRoute (static "settings")
        ]


toPath : Page -> String
toPath page =
    case page of
        TimelineRoute ->
            "#"

        SearchRoute ->
            "#search"

        CreateAccountRoute ->
            "#account/create"

        FollowingListRoute ->
            "#following"

        ProfileRoute hash ->
            "#profile/" ++ hash

        SettingsRoute ->
            "#settings"


pathParser : Navigation.Location -> Result String Page
pathParser location =
    UrlParser.parse identity pageParser (String.dropLeft 1 location.pathname)


urlParser : Navigation.Parser (Result String Page)
urlParser =
    Navigation.makeParser pathParser


static : String -> Parser a a
static =
    s
