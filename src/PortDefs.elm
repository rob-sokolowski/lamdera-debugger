port module PortDefs exposing (jsonify)

import Dict exposing (Dict)
import Json.Encode as JE
import Types exposing (BackendModel, InnerBackendModel, Msg_)


type alias JsonStr =
    String


port jsonify : JE.Value -> Cmd msg


port returnJsonStr : (JsonStr -> msg) -> Sub msg
