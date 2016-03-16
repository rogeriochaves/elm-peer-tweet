module Download.Update (update) where

import Action as RootAction exposing (..)
import Download.Action as Download exposing (..)
import Download.Model exposing (Model, Status(..), updateDownloadingItem)
import Account.Model exposing (Hash)


update : RootAction.Action -> Model -> Model
update action model =
  case action of
    ActionForDownload syncAction ->
      updateDownload syncAction model

    _ ->
      model


updateDownload : Download.Action -> Model -> Model
updateDownload action model =
  let
    setLoading = incDownloadingCount model
    setDone = decDownloadingCount model
  in
  case action of
    BeginDownload ->
      model

    DownloadHead hash ->
      setLoading hash

    DoneDownloadHead { hash } ->
      setDone hash

    DownloadTweet { tweetHash } ->
      setLoading tweetHash

    DoneDownloadTweet { tweet } ->
      setDone tweet.hash

    DownloadFollowBlock { followBlockHash } ->
      setLoading followBlockHash

    DoneDownloadFollowBlock { followBlock } ->
      setDone followBlock.hash


incDownloadingCount : Model -> Hash -> Model
incDownloadingCount model hash =
  { model | downloadingItems = updateDownloadingItem model hash Loading }


decDownloadingCount : Model -> Hash -> Model
decDownloadingCount model hash =
  { model | downloadingItems = updateDownloadingItem model hash Done }
