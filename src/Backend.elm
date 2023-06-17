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
    ( BackendModel_
        { history = []
        , msgs = []
        , codes = Dict.empty
        }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    let
        -- Note: unwrap, since its recursive
        model_ =
            case model of
                BackendModel_ m ->
                    m
    in
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )

        LogMsg clientId msg_ ->
            let
                msgs_ =
                    msg_ :: model_.msgs

                history_ =
                    model :: model_.history

                newModel : BackendModel
                newModel =
                    BackendModel_ { model_ | msgs = msgs_, history = history_ }
            in
            ( newModel, sendToFrontend clientId (UpdateDebugger newModel) )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    let
        -- Note: unwrap, since its recursive
        model_ =
            case model of
                BackendModel_ m ->
                    m

        cmd_ : Msg_ -> BackendMsg
        cmd_ =
            LogMsg clientId
    in
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        MessageType1 ->
            let
                currentVal =
                    Dict.get 1 model_.codes

                newVal =
                    case currentVal of
                        Nothing ->
                            1

                        Just val ->
                            val + 1
            in
            ( BackendModel_ { model_ | codes = Dict.insert 1 newVal model_.codes }
            , send <| cmd_ (Msg_ToBackend MessageType1)
            )

        MessageType2 ->
            let
                currentVal =
                    Dict.get 2 model_.codes

                newVal =
                    case currentVal of
                        Nothing ->
                            1

                        Just val ->
                            val + 1
            in
            ( BackendModel_ { model_ | codes = Dict.insert 1 newVal model_.codes }
            , send <| cmd_ (Msg_ToBackend MessageType2)
            )

        MessageType3 ->
            let
                currentVal =
                    Dict.get 2 model_.codes

                newVal =
                    case currentVal of
                        Nothing ->
                            1

                        Just val ->
                            val + 1
            in
            ( BackendModel_ { model_ | codes = Dict.insert 1 newVal model_.codes }
            , send <| cmd_ (Msg_ToBackend MessageType3)
            )

        MessageType4 ->
            let
                currentVal =
                    Dict.get 2 model_.codes

                newVal =
                    case currentVal of
                        Nothing ->
                            1

                        Just val ->
                            val + 1
            in
            ( BackendModel_ { model_ | codes = Dict.insert 1 newVal model_.codes }
            , send <| cmd_ (Msg_ToBackend MessageType4)
            )
