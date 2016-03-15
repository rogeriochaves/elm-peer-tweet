module Router.Action (Action(..)) where

import Router.Routes exposing (Sitemap)


type Action
  = PathChange String
  | UpdatePath Sitemap
