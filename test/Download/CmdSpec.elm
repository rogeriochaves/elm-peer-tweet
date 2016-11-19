module Download.CmdSpec exposing (..)

import Download.Cmd exposing (cmds)
import Download.Msg as Download exposing (..)
import ElmTestBDDStyle exposing (..)
import Msg as RootMsg exposing (..)
import Accounts.Model as Accounts
import Authentication.Model as Authentication
import Download.Ports exposing (requestDownloadHead)


model : { accounts : Accounts.Model, authentication : Authentication.Model }
model =
    { accounts = Accounts.initialModel, authentication = Authentication.initialModel (Just "foo") }


tests : Test
tests =
    describe "Download.Cmd"
        [ it "starts downloading head using the requestDownloadHead port"
            <| expect (cmds (MsgForDownload <| DownloadHead "foo") model)
                toBe
            <| requestDownloadHead "foo"
        ]
