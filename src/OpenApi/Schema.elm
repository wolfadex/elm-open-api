module OpenApi.Schema exposing (Schema, decode)

import Json.Decode exposing (Decoder)
import OpenApi.Types


type alias Schema =
    OpenApi.Types.Schema


decode : Decoder Schema
decode =
    OpenApi.Types.decodeSchema
