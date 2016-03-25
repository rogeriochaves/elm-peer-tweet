module Router.Model (..) where

import Router.Routes exposing (Sitemap(..), match, route)
import Account.Model exposing (HeadHash)


type Page
  = Timeline
  | Search
  | NotFound
  | CreateAccount
  | FollowingList
  | Profile HeadHash


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

    FollowingListRoute () ->
      FollowingList

    ProfileRoute hash ->
      Profile hash


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
