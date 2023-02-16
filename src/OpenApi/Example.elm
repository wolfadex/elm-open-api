module OpenApi.Example exposing
    ( Example
    , decode
    , description
    , externalValue
    , summary
    , value
    )

{-| Corresponds to the [Example Object](https://spec.openapis.org/oas/latest.html#example-object) in the OpenAPI specification.


# Types

@docs Example


# Decoding

@docs decode


# Querying

@docs description
@docs externalValue
@docs summary
@docs value

-}

import Json.Decode exposing (Decoder, Value)
import OpenApi.Types exposing (Example(..))



-- Types


{-| -}
type alias Example =
    OpenApi.Types.Example



-- Decoding


{-| -}
decode : Decoder Example
decode =
    OpenApi.Types.decodeExample



-- Querying


{-| -}
summary : Example -> Maybe String
summary (Example example) =
    example.summary


{-| -}
description : Example -> Maybe String
description (Example example) =
    example.description


{-| -}
value : Example -> Maybe Value
value (Example example) =
    example.value


{-| -}
externalValue : Example -> Maybe String
externalValue (Example example) =
    example.externalValue
