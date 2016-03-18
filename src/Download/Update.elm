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
    setLoading =
      setDownloadLoading model

    setDone =
      setDownloadDone model

    setError =
      setDownloadError model
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

      ErrorDownload hash message ->
        setError hash message


setDownloadLoading : Model -> Hash -> Model
setDownloadLoading model hash =
  { model | downloadingItems = updateDownloadingItem model hash Loading }


setDownloadDone : Model -> Hash -> Model
setDownloadDone model hash =
  { model | downloadingItems = updateDownloadingItem model hash Done }


setDownloadError : Model -> Hash -> String -> Model
setDownloadError model hash message =
  { model | downloadingItems = updateDownloadingItem model hash <| Error message }
