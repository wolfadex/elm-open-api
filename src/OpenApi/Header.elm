module OpenApi.Header exposing (Header, decode)

import Json.Decode exposing (Decoder)
import OpenApi.Types


type alias Header =
    OpenApi.Types.Header


decode : Decoder Header
decode =
    OpenApi.Types.decodeHeader
