module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Lamdera exposing (ClientId)
import Task
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , message : String
    , debugState : Maybe BackendModel
    }


type alias InnerBackendModel =
    { history : List BackendModel
    , msgs : List Msg_
    , codes : Dict Int Int
    }


type BackendModel
    = BackendModel_ InnerBackendModel


type Msg_
    = Msg_ToFrontend ToFrontend
    | Msg_ToBackend ToBackend
    | Msg_Backend BackendMsg


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | UserClickedMessageCode Int
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend
    | MessageType1
    | MessageType2
    | MessageType3
    | MessageType4


type BackendMsg
    = NoOpBackendMsg
    | LogMsg ClientId Msg_


type ToFrontend
    = NoOpToFrontend
    | UpdateDebugger BackendModel


send : msg -> Cmd msg
send m =
    Task.succeed m
        |> Task.perform identity
