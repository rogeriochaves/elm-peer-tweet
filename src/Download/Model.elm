module Download.Model (Model, initialModel, Status(..), updateDownloadingItem, downloadingItemsCount, isLoading) where

import Account.Model exposing (Hash)


type Status
  = Loading
  | Error String
  | Done


type RemoteItem
  = Item Hash Status


type alias Model =
  { downloadingItems : List RemoteItem
  }


initialModel : Model
initialModel =
  { downloadingItems = []
  }


toRecord : RemoteItem -> { hash : Hash, status : Status }
toRecord item =
  case item of
    Item hash status ->
      { hash = hash, status = status }


findDownloadingItem : Model -> Hash -> Maybe RemoteItem
findDownloadingItem model hash =
  model.downloadingItems
    |> List.filter (\item -> (toRecord item).hash == hash)
    |> List.head


updateDownloadingItem : Model -> Hash -> Status -> List RemoteItem
updateDownloadingItem model hash status =
  let
    foundItem =
      findDownloadingItem model hash

    updateItem item =
      if (toRecord item).hash == hash then
        Item hash status
      else
        item
  in
    case foundItem of
      Just item ->
        model.downloadingItems
          |> List.map (updateItem)

      Nothing ->
        (Item hash status) :: model.downloadingItems


downloadingItemsCount : Model -> Int
downloadingItemsCount model =
  let
    addCount item total =
      if (toRecord item).status == Loading then
        total + 1
      else
        total
  in
    model.downloadingItems
      |> List.foldl addCount 0


isLoading : Model -> Hash -> Bool
isLoading model hash =
  findDownloadingItem model hash
    |> Maybe.map (toRecord >> .status >> (==) Loading)
    |> Maybe.withDefault False
