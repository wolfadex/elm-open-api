module OpenApi.Callback exposing (Callback, decode)

import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (Callback(..))


type alias Callback =
    OpenApi.Types.Callback


decode : Decoder Callback
decode =
    OpenApi.Types.decodeCallback
