module OpenApi.Parameter exposing
    ( Location
    , Parameter
    , decode
    )

import Json.Decode exposing (Decoder)
import OpenApi.Types


type alias Parameter =
    OpenApi.Types.Parameter


type alias Location =
    OpenApi.Types.Location


decode : Decoder Parameter
decode =
    OpenApi.Types.decodeParameter
