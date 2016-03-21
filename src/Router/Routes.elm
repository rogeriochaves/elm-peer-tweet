module Router.Routes (Sitemap(..), match, route) where

import Route exposing (..)
import String


type Sitemap
  = TimelineRoute ()
  | SearchRoute ()
  | CreateAccountRoute ()
  | FollowingListRoute ()


timelineRoute : Route Sitemap
timelineRoute =
  TimelineRoute := static ""


searchRoute : Route Sitemap
searchRoute =
  SearchRoute := static "search"


createAccountRoute : Route Sitemap
createAccountRoute =
  CreateAccountRoute := static "account" <> "create"


followingListRoute : Route Sitemap
followingListRoute =
  FollowingListRoute := static "following"


sitemap : Router Sitemap
sitemap =
  router [ timelineRoute, searchRoute, createAccountRoute, followingListRoute ]


match : String -> Maybe Sitemap
match =
  String.dropLeft 1 >> Route.match sitemap


route : Sitemap -> String
route r =
  let
    route =
      case r of
        TimelineRoute () ->
          reverse timelineRoute []

        SearchRoute () ->
          reverse searchRoute []

        CreateAccountRoute () ->
          reverse createAccountRoute []

        FollowingListRoute () ->
          reverse followingListRoute []
  in
    "#" ++ route
