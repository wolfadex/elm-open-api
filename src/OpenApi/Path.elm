module OpenApi.Path exposing (Path, decode)

import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (Path(..))


type alias Path =
    OpenApi.Types.Path


decode : Decoder Path
decode =
    OpenApi.Types.decodePath
