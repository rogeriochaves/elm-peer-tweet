module Download.Update exposing (update)

import Msg as RootMsg exposing (..)
import Download.Msg as Download exposing (..)
import Download.Model exposing (Model, Status(..), updateDownloadingItem)
import Account.Model exposing (Hash)


update : RootMsg.Msg -> Model -> Model
update msg model =
    case msg of
        MsgForDownload syncMsg ->
            updateDownload syncMsg model

        _ ->
            model


updateDownload : Download.Msg -> Model -> Model
updateDownload msg model =
    let
        setLoading =
            setDownloadLoading model

        setDone =
            setDownloadDone model

        setError =
            setDownloadError model
    in
        case msg of
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
