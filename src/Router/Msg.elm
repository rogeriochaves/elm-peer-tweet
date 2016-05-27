module Router.Msg (Msg(..)) where

import Router.Routes exposing (Sitemap)


type Msg
  = PathChange String
  | UpdatePath Sitemap
