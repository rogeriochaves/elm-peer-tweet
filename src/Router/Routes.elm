module Router.Routes exposing (Sitemap(..), match, route)

import Route exposing (..)
import Account.Model exposing (HeadHash)
import String


type Sitemap
  = TimelineRoute ()
  | SearchRoute ()
  | CreateAccountRoute ()
  | FollowingListRoute ()
  | ProfileRoute HeadHash
  | SettingsRoute ()


routes : { a : Route Sitemap, b : Route Sitemap, c : Route Sitemap, d : Route Sitemap, e : Route Sitemap, f : Route Sitemap }
routes =
  { a = TimelineRoute := static ""
  , b = SearchRoute := static "search"
  , c = CreateAccountRoute := static "account" <> "create"
  , d = FollowingListRoute := static "following"
  , e = ProfileRoute := "profile" <//> string
  , f = SettingsRoute := static "settings"
  }


sitemap : Router Sitemap
sitemap =
  router [ routes.a, routes.b, routes.c, routes.d, routes.e, routes.f ]


route : Sitemap -> String
route r =
  let
    route =
      case r of
        TimelineRoute () ->
          reverse routes.a []

        SearchRoute () ->
          reverse routes.b []

        CreateAccountRoute () ->
          reverse routes.c []

        FollowingListRoute () ->
          reverse routes.d []

        ProfileRoute hash ->
          reverse routes.e [ hash ]

        SettingsRoute () ->
          reverse routes.f []
  in
    "#" ++ route


match : String -> Maybe Sitemap
match =
  String.dropLeft 1 >> Route.match sitemap
