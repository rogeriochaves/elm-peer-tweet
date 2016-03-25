module Router.Routes (Sitemap(..), match, route) where

import Route exposing (..)
import Account.Model exposing (HeadHash)
import String


type Sitemap
  = TimelineRoute ()
  | SearchRoute ()
  | CreateAccountRoute ()
  | FollowingListRoute ()
  | ProfileRoute HeadHash


routes : { a : Route Sitemap, b : Route Sitemap, c : Route Sitemap, d : Route Sitemap, e : Route Sitemap }
routes =
  { a = TimelineRoute := static ""
  , b = SearchRoute := static "search"
  , c = CreateAccountRoute := static "account" <> "create"
  , d = FollowingListRoute := static "following"
  , e = ProfileRoute := "profile" <//> string
  }


sitemap : Router Sitemap
sitemap =
  router [ routes.a, routes.b, routes.c, routes.d, routes.e ]


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
  in
    "#" ++ route


match : String -> Maybe Sitemap
match =
  String.dropLeft 1 >> Route.match sitemap
