port module PortDefs exposing (jsonify)

import Json.Encode as JE


port jsonify : JE.Value -> Cmd msg
