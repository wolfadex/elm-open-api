module OpenApi.Example exposing
    ( Example
    , decode
    , encode
    , description
    , externalValue
    , summary
    , value
    )

{-| Corresponds to the [Example Object](https://spec.openapis.org/oas/latest.html#example-object) in the OpenAPI specification.


# Types

@docs Example


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs description
@docs externalValue
@docs summary
@docs value

-}

import Json.Decode
import Json.Encode
import OpenApi.Types exposing (Example(..))



-- Types


{-| -}
type alias Example =
    OpenApi.Types.Example



-- Decoding


{-| -}
decode : Json.Decode.Decoder Example
decode =
    OpenApi.Types.decodeExample


{-| -}
encode : Example -> Json.Encode.Value
encode =
    OpenApi.Types.encodeExample



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
value : Example -> Maybe Json.Encode.Value
value (Example example) =
    example.value


{-| -}
externalValue : Example -> Maybe String
externalValue (Example example) =
    example.externalValue
