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
    , backendModelHist : List BackendModel
    , backendMsgHist : List BackendMsg
    , toBackendMsgHist : List ToBackend
    }


type alias BackendModel =
    { counts : Dict Int Int -- lane # => incrementer value
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | UserClickIncrement Int
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend
      -- Not: 'lane' refers to which value to increment, so 4 lanes = 4 separate counters
    | IncrementLane Int


type BackendMsg
    = NoOpBackendMsg
    | Debug_Log ClientId ToBackend


type ToFrontend
    = NoOpToFrontend
    | Debugger_Update ToBackend BackendModel


send : msg -> Cmd msg
send m =
    Task.succeed m
        |> Task.perform identity
