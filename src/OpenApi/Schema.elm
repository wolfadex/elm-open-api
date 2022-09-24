module OpenApi.Schema exposing (Schema, decode)

import Json.Decode exposing (Decoder)
import OpenApi.Types


type alias Schema =
    OpenApi.Types.Schema


decode : Decoder Schema
decode =
    Json.Decode.map
        (\schema_ ->
            Debug.todo "implement schema"
        )
        Json.Decode.value
