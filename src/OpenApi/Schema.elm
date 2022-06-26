module OpenApi.Schema exposing (Schema, decode)

import Json.Decode exposing (Decoder)


type Schema
    = Schema Internal


type alias Internal =
    Json.Decode.Value


decode : Decoder Schema
decode =
    Json.Decode.map
        (\schema_ ->
            Debug.todo "implement schema"
        )
        Json.Decode.value
