module Router.Routes (Sitemap(..), match, route) where

import Route exposing (..)
import String


type Sitemap
  = TimelineRoute ()
  | SearchRoute ()


timelineRoute : Route Sitemap
timelineRoute =
  TimelineRoute := static ""


searchRoute : Route Sitemap
searchRoute =
  SearchRoute := static "search"


sitemap : Router Sitemap
sitemap =
  router [ timelineRoute, searchRoute ]


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
  in
    "#" ++ route
