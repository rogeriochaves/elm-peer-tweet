port module Download.Ports exposing (..)

import Account.Model as Account exposing (Hash, Head, Tweet, HeadHash, TweetHash)
import Msg as RootMsg exposing (..)
import Download.Msg exposing (..)
import Time exposing (every, second)
import Account.Msg exposing (TweetIdentifier, TweetData, FollowBlockIdentifier, FollowBlockData)


type alias Error =
    ( Hash, String )


requestDownload : Sub RootMsg.Msg
requestDownload =
    MsgForDownload BeginDownload
        |> always
        |> every (30 * second)


port downloadHeadStream : (Maybe Head -> msg) -> Sub msg


port downloadErrorStream : (Maybe Error -> msg) -> Sub msg


port requestDownloadHead : HeadHash -> Cmd msg


downloadErrorInput : Sub RootMsg.Msg
downloadErrorInput =
    let
        msg ( hash, errorMessage ) =
            MsgForDownload <| ErrorDownload hash errorMessage
    in
        downloadErrorStream (Maybe.map msg >> Maybe.withDefault NoOp)


downloadHeadInput : Sub RootMsg.Msg
downloadHeadInput =
    downloadHeadStream (Maybe.map (MsgForDownload << DoneDownloadHead) >> Maybe.withDefault NoOp)


port downloadTweetStream : (Maybe TweetData -> msg) -> Sub msg


port requestDownloadTweet : TweetIdentifier -> Cmd msg


downloadTweetInput : Sub RootMsg.Msg
downloadTweetInput =
    downloadTweetStream (Maybe.map (MsgForDownload << DoneDownloadTweet) >> Maybe.withDefault NoOp)


port downloadFollowBlockStream : (Maybe FollowBlockData -> msg) -> Sub msg


port requestDownloadFollowBlock : FollowBlockIdentifier -> Cmd msg


downloadFollowBlockInput : Sub RootMsg.Msg
downloadFollowBlockInput =
    downloadFollowBlockStream (Maybe.map (MsgForDownload << DoneDownloadFollowBlock) >> Maybe.withDefault NoOp)
