module Download.Cmd exposing (cmds, initialCmd)

import Msg as RootMsg exposing (..)
import Download.Msg as Download exposing (..)
import Account.Model as Account
import Account.Model exposing (Hash, HeadHash, nextHash, nextHashToDownload)
import Maybe exposing (andThen)
import Accounts.Model as Accounts exposing (findAccount, getUserAccount, followingAccounts)
import Authentication.Model as Authentication
import Download.Ports exposing (..)
import Authentication.Msg exposing (Msg(DoneLogin))
import Utils.Utils exposing (nextMsg)


cmds : RootMsg.Msg -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Cmd RootMsg.Msg
cmds msg model =
    case msg of
        MsgForDownload syncMsg ->
            cmdsDownload syncMsg model

        MsgForAuthentication (DoneLogin hash) ->
            nextMsg (MsgForDownload <| DownloadHead hash)

        _ ->
            Cmd.none


cmdsDownload : Download.Msg -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Cmd RootMsg.Msg
cmdsDownload msg model =
    case msg of
        BeginDownload ->
            let
                msg =
                    nextMsg << MsgForDownload << DownloadHead << .hash << .head
            in
                case getUserAccount model of
                    Just userAccount ->
                        userAccount
                            :: (followingAccounts model.accounts userAccount)
                            |> List.map msg
                            |> Cmd.batch

                    Nothing ->
                        Cmd.none

        DownloadHead hash ->
            requestDownloadHead hash

        DoneDownloadHead head ->
            Cmd.batch
                [ nextDownloadTweetCmd head.hash model.accounts <| nextHash (Just head)
                , downloadFirstFollowBlockCmd head
                ]

        DownloadTweet { headHash, tweetHash } ->
            requestDownloadTweet { headHash = headHash, tweetHash = tweetHash }

        DoneDownloadTweet { headHash, tweet } ->
            nextDownloadTweetCmd headHash model.accounts <| nextHash (Just tweet)

        DownloadFollowBlock { headHash, followBlockHash } ->
            requestDownloadFollowBlock { headHash = headHash, followBlockHash = followBlockHash }

        DoneDownloadFollowBlock { headHash, followBlock } ->
            Cmd.batch
                [ nextDownloadFollowBlockCmd headHash model.accounts <| nextHash (Just followBlock)
                , if (Just headHash) == model.authentication.hash then
                    downloadFollowerCmd followBlock
                  else
                    Cmd.none
                ]

        ErrorDownload _ _ ->
            Cmd.none


initialCmd : Authentication.Model -> Cmd RootMsg.Msg
initialCmd accounts =
    case accounts.hash of
        Just hash ->
            nextMsg (MsgForDownload <| DownloadHead hash)

        Nothing ->
            Cmd.none


nextDownloadCmd : (Account.Model -> List { a | hash : Hash, next : List Hash }) -> (Hash -> RootMsg.Msg) -> HeadHash -> Accounts.Model -> Maybe Hash -> Cmd RootMsg.Msg
nextDownloadCmd nextListKey msgFn headHash accounts followBlockHash =
    let
        nextItem =
            findAccount accounts (Just headHash)
                |> Maybe.map (\account -> followBlockHash `andThen` nextHashToDownload (nextListKey account))
                |> Maybe.withDefault followBlockHash
    in
        nextItem
            |> Maybe.map (nextMsg << msgFn)
            |> Maybe.withDefault Cmd.none


nextDownloadTweetCmd : HeadHash -> Accounts.Model -> Maybe Hash -> Cmd RootMsg.Msg
nextDownloadTweetCmd headHash =
    nextDownloadCmd .tweets
        (\hash -> MsgForDownload <| DownloadTweet { headHash = headHash, tweetHash = hash })
        headHash


nextDownloadFollowBlockCmd : HeadHash -> Accounts.Model -> Maybe Hash -> Cmd RootMsg.Msg
nextDownloadFollowBlockCmd headHash =
    nextDownloadCmd .followBlocks
        (\hash -> MsgForDownload <| DownloadFollowBlock { headHash = headHash, followBlockHash = hash })
        headHash


downloadFirstFollowBlockCmd : Account.Head -> Cmd RootMsg.Msg
downloadFirstFollowBlockCmd head =
    let
        foundFollowBlockHash =
            List.head head.f
    in
        case foundFollowBlockHash of
            Just followBlockHash ->
                nextMsg <| MsgForDownload <| DownloadFollowBlock { headHash = head.hash, followBlockHash = followBlockHash }

            Nothing ->
                Cmd.none


downloadFollowerCmd : Account.FollowBlock -> Cmd RootMsg.Msg
downloadFollowerCmd followBlock =
    followBlock.l
        |> List.map (nextMsg << MsgForDownload << DownloadHead)
        |> Cmd.batch
