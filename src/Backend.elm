module Backend exposing (..)

import Dict
import Lamdera exposing (ClientId, SessionId, sendToFrontend)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { counts = Dict.empty
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        Debug_Log clientId toBackend ->
            ( model, sendToFrontend clientId (Debugger_Update toBackend model) )


isDebugEnabled =
    True


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    let
        cmd_ : Cmd BackendMsg
        cmd_ =
            if isDebugEnabled then
                send (Debug_Log clientId msg)

            else
                Cmd.none
    in
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        IncrementLane laneNo ->
            let
                newVal =
                    case Dict.get laneNo model.counts of
                        Nothing ->
                            1

                        Just val ->
                            val + 1
            in
            ( { model | counts = Dict.insert laneNo newVal model.counts }
            , cmd_
            )
