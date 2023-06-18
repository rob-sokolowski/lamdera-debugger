module Backend exposing (..)

import Dict
import Lamdera exposing (ClientId, SessionId, broadcast, sendToFrontend)
import Types exposing (..)


type alias Model =
    BackendModel


shouldDebug =
    True


app =
    if shouldDebug then
        Lamdera.backend
            { init = init
            , update = update_debug
            , updateFromFrontend = updateFromFrontend_debug
            , subscriptions = \m -> Sub.none
            }

    else
        Lamdera.backend
            { init = init
            , update = update
            , updateFromFrontend = updateFromFrontend
            , subscriptions = \m -> Sub.none
            }


update_debug : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update_debug msg model =
    let
        ( model_, cmd_ ) =
            case msg of
                Debug_Log debug_Msg ->
                    ( model, broadcast <| Debug_UpdateFrontend debug_Msg model )

                _ ->
                    update msg model
    in
    ( model_
    , cmd_
    )


updateFromFrontend_debug : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend_debug sessionId clientId msg model =
    let
        ( model_, cmd_ ) =
            updateFromFrontend sessionId clientId msg model
    in
    ( model_
    , Cmd.batch
        [ send <| Debug_Log (Debug_ToBackend msg)
        , cmd_
        ]
    )


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

        Debug_Log debug_Msg ->
            -- Noop
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
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
            , Cmd.none
            )
