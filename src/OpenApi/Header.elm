module OpenApi.Header exposing (Header, decode)

import Json.Decode exposing (Decoder)


type Header
    = Header Internal


type alias Internal =
    {}


decode : Decoder Header
decode =
    Debug.todo ""
