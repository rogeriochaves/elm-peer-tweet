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
import Utils.Utils exposing (nextMsg)


cmds : RootMsg.Msg -> { a | accounts : Accounts.Model, authentication : Authentication.Model } -> Cmd RootMsg.Msg
cmds msg model =
    case msg of
        MsgForPublish syncMsg ->
            cmdsPublish syncMsg model

        MsgForAccounts (UpdateUserAccount userAccount) ->
            nextMsg (MsgForPublish <| PublishHead userAccount.head)

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
                nextMsg publishMsg

        PublishHead head ->
            Cmd.batch
                [ requestPublishHead head
                , nextPublishTweetMsg head.hash model.accounts head
                , publishFirstFollowBlockCmd model.accounts head
                ]

        DonePublishHead _ ->
            Cmd.none

        PublishTweet payload ->
            Cmd.batch
                [ requestPublishTweet payload
                , nextPublishTweetMsg payload.headHash model.accounts payload.tweet
                ]

        DonePublishTweet _ ->
            Cmd.none

        PublishFollowBlock payload ->
            Cmd.batch
                [ requestPublishFollowBlock payload
                , nextPublishFollowBlockMsg payload.headHash model.accounts payload.followBlock
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
            findAccount accounts (Just head.hash) |> andThen firstFollowBlock
    in
        case foundFollowBlock of
            Just followBlock ->
                nextMsg (MsgForPublish <| PublishFollowBlock { headHash = head.hash, followBlock = followBlock })

            Nothing ->
                Cmd.none


nextItemMsg : (Account.Model -> List { a | hash : Hash, next : List Hash }) -> ({ a | hash : Hash, next : List Hash } -> RootMsg.Msg) -> HeadHash -> Accounts.Model -> { b | next : List Hash } -> Cmd RootMsg.Msg
nextItemMsg listKey msgFn headHash accounts item =
    let
        hash =
            nextHash (Just item)

        foundItem =
            findAccount accounts (Just headHash) |> andThen (\account -> findItem (listKey account) hash)
    in
        foundItem
            |> Maybe.map (nextMsg << msgFn)
            |> Maybe.withDefault Cmd.none


nextPublishTweetMsg : HeadHash -> Accounts.Model -> { a | next : List TweetHash } -> Cmd RootMsg.Msg
nextPublishTweetMsg headHash =
    nextItemMsg .tweets
        (\tweet -> MsgForPublish (PublishTweet { headHash = headHash, tweet = tweet }))
        headHash


nextPublishFollowBlockMsg : HeadHash -> Accounts.Model -> { a | next : List FollowBlockHash } -> Cmd RootMsg.Msg
nextPublishFollowBlockMsg headHash =
    nextItemMsg .followBlocks
        (\followBlock -> MsgForPublish (PublishFollowBlock { headHash = headHash, followBlock = followBlock }))
        headHash


publishFollowerCmd : Accounts.Model -> Account.FollowBlock -> Cmd RootMsg.Msg
publishFollowerCmd accounts followBlock =
    let
        effectMap hash =
            findAccount accounts (Just hash)
                |> Maybe.map (nextMsg << MsgForPublish << PublishHead << .head)
                |> Maybe.withDefault Cmd.none
    in
        followBlock.l
            |> List.map effectMap
            |> Cmd.batch
