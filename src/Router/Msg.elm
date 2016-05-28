module Router.Msg exposing (Msg(..))

import Router.Routes exposing (Sitemap)


type Msg
  = PathChange String
  | UpdatePath Sitemap
