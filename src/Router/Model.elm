module Router.Model (..) where

import Router.Routes exposing (Sitemap(..), match, route)


type Page
  = Timeline
  | Search
  | NotFound
  | CreateAccount


type alias Model =
  { page : Page
  }


routeToPage : Sitemap -> Page
routeToPage route =
  case route of
    TimelineRoute () ->
      Timeline

    SearchRoute () ->
      Search

    CreateAccountRoute () ->
      CreateAccount


pathToPage : String -> Page
pathToPage page =
  case match page of
    Nothing ->
      NotFound

    Just r ->
      routeToPage r


initialModel : String -> Model
initialModel path =
  { page = pathToPage path }
