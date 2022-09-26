module OpenApi.SecurityRequirement exposing
    ( SecurityRequirement
    , decode
    , requirements
    )

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (SecurityRequirement(..))


type alias SecurityRequirement =
    OpenApi.Types.SecurityRequirement


decode : Decoder SecurityRequirement
decode =
    OpenApi.Types.decodeSecurityRequirement


requirements : SecurityRequirement -> Dict String (List String)
requirements (SecurityRequirement reqs) =
    reqs
