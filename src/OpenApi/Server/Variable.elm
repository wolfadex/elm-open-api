module OpenApi.Server.Variable exposing
    ( Variable
    , decode
    , encode
    , default
    , description
    , enum
    )

{-| Corresponds to the [Server Variable Object](https://spec.openapis.org/oas/latest.html#server-variable-object) in the OpenAPI specification.


# Types

@docs Variable


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs default
@docs description
@docs enum

-}

import Json.Decode exposing (Decoder)
import Json.Encode
import OpenApi.Types exposing (Variable(..))


{-| -}
type alias Variable =
    OpenApi.Types.Variable


{-| -}
decode : Decoder Variable
decode =
    OpenApi.Types.decodeServerVariable


{-| -}
encode : Variable -> Json.Encode.Value
encode =
    OpenApi.Types.encodeServerVariable


{-| -}
default : Variable -> String
default (Variable variable) =
    variable.default


{-| -}
enum : Variable -> List String
enum (Variable variable) =
    variable.enum


{-| -}
description : Variable -> Maybe String
description (Variable variable) =
    variable.description
