module OpenApi.Operation exposing (Operation, decode)

import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (Operation(..))


type alias Operation =
    OpenApi.Types.Operation


decode : Decoder Operation
decode =
    OpenApi.Types.decodeOperation
