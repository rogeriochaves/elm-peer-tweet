module Router.Routes exposing (..)

import Account.Model exposing (HeadHash)
import UrlParser exposing (Parser, (</>), map, oneOf, s, string, parseHash)
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
        [ map TimelineRoute (static "")
        , map SearchRoute (static "search")
        , map CreateAccountRoute (static "account" </> static "create")
        , map FollowingListRoute (static "following")
        , map ProfileRoute (static "profile" </> string)
        , map SettingsRoute (static "settings")
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


pathParser : Navigation.Location -> Maybe Page
pathParser location =
    parseHash pageParser location


static : String -> Parser a a
static =
    s
