module OpenApi.SecurityRequirement exposing
    ( SecurityRequirement
    , decode
    , encode
    , requirements
    )

{-| Corresponds to the [Security Requirement Object](https://spec.openapis.org/oas/latest#security-requirement-object) in the OpenAPI specification.


# Types

@docs SecurityRequirement


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs requirements

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import Json.Encode
import OpenApi.Types exposing (SecurityRequirement(..))


{-| -}
type alias SecurityRequirement =
    OpenApi.Types.SecurityRequirement


{-| -}
decode : Decoder SecurityRequirement
decode =
    OpenApi.Types.decodeSecurityRequirement


{-| -}
encode : SecurityRequirement -> Json.Encode.Value
encode =
    OpenApi.Types.encodeSecurityRequirement


{-| -}
requirements : SecurityRequirement -> Dict String (List String)
requirements (SecurityRequirement reqs) =
    reqs
