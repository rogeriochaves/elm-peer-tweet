module Download.Action (..) where

import Data.Model exposing (Hash, Head, Tweet)


type Action
  = BeginDownload
  | DownloadHead Hash
  | DoneDownloadHead Head
  | DownloadTweet Hash
  | DoneDownloadTweet Tweet
