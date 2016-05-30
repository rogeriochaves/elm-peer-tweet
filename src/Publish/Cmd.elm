module Publish.Cmd exposing (cmds)

import Msg as RootMsg exposing (..)
import Publish.Msg as Publish exposing (..)
import Account.Model as Account
import Accounts.Model as Accounts exposing (getUserAccount, findAccount)
import Account.Model exposing (HeadHash, TweetHash, FollowBlockHash, Hash, FollowBlock, nextHash, firstFollowBlock, findItem)
import Maybe exposing (andThen)
import Authentication.Model as Authentication
import Publish.Ports exposing (..)
import Accounts.Msg exposing (Msg(UpdateUserAccount))


cmds : RootMsg.Msg -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Cmd RootMsg.Msg
cmds msg model =
    case msg of
        MsgForPublish syncMsg ->
            cmdsPublish syncMsg model

        MsgForAccounts (UpdateUserAccount userAccount) ->
            cmdsPublish (PublishHead <| .head <| userAccount) model

        _ ->
            Cmd.none


cmdsPublish : Publish.Msg -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Cmd RootMsg.Msg
cmdsPublish msg model =
    case msg of
        BeginPublish ->
            let
                publishMsg =
                    getUserAccount model
                        |> Maybe.map (MsgForPublish << PublishHead << .head)
                        |> Maybe.withDefault NoOp
            in
                cmds publishMsg model

        PublishHead head ->
            Cmd.batch
                [ requestPublishHead head
                , cmds (nextPublishTweetMsg head.hash model.accounts head) model
                , publishFirstFollowBlockCmd model.accounts head
                ]

        DonePublishHead _ ->
            Cmd.none

        PublishTweet payload ->
            Cmd.batch
                [ requestPublishTweet payload
                , cmds (nextPublishTweetMsg payload.headHash model.accounts payload.tweet) model
                ]

        DonePublishTweet _ ->
            Cmd.none

        PublishFollowBlock payload ->
            Cmd.batch
                [ requestPublishFollowBlock payload
                , cmds (nextPublishFollowBlockMsg payload.headHash model.accounts payload.followBlock) model
                , if (Just payload.headHash) == model.authentication.hash then
                    publishFollowerCmd model.accounts payload.followBlock
                  else
                    Cmd.none
                ]

        DonePublishFollowBlock _ ->
            Cmd.none


publishFirstFollowBlockCmd : Accounts.Model -> Account.Head -> Cmd RootMsg.Msg
publishFirstFollowBlockCmd accounts head =
    let
        foundFollowBlock =
            findAccount accounts (Just head.hash) `andThen` firstFollowBlock
    in
        case foundFollowBlock of
            Just followBlock ->
                requestPublishFollowBlock { headHash = head.hash, followBlock = followBlock }

            Nothing ->
                Cmd.none


nextItemMsg : (Account.Model -> List { a | hash : Hash, next : List Hash }) -> ({ a | hash : Hash, next : List Hash } -> RootMsg.Msg) -> HeadHash -> Accounts.Model -> { b | next : List Hash } -> RootMsg.Msg
nextItemMsg listKey msgFn headHash accounts item =
    let
        hash =
            nextHash (Just item)

        foundItem =
            findAccount accounts (Just headHash) `andThen` (\account -> findItem (listKey account) hash)
    in
        foundItem
            |> Maybe.map msgFn
            |> Maybe.withDefault NoOp


nextPublishTweetMsg : HeadHash -> Accounts.Model -> { a | next : List TweetHash } -> RootMsg.Msg
nextPublishTweetMsg headHash =
    nextItemMsg .tweets
        (\tweet -> MsgForPublish (PublishTweet { headHash = headHash, tweet = tweet }))
        headHash


nextPublishFollowBlockMsg : HeadHash -> Accounts.Model -> { a | next : List FollowBlockHash } -> RootMsg.Msg
nextPublishFollowBlockMsg headHash =
    nextItemMsg .followBlocks
        (\followBlock -> MsgForPublish (PublishFollowBlock { headHash = headHash, followBlock = followBlock }))
        headHash


publishFollowerCmd : Accounts.Model -> Account.FollowBlock -> Cmd RootMsg.Msg
publishFollowerCmd accounts followBlock =
    let
        effectMap hash =
            findAccount accounts (Just hash)
                |> Maybe.map (requestPublishHead << .head)
                |> Maybe.withDefault Cmd.none
    in
        followBlock.l
            |> List.map effectMap
            |> Cmd.batch
