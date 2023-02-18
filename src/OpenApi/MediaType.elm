module OpenApi.MediaType exposing
    ( MediaType
    , decode
    , encode
    , encoding
    , example
    , examples
    , schema
    )

{-| Corresponds to the [MediaType Object](https://spec.openapis.org/oas/latest.html#media-type-object) in the OpenAPI specification.


# Types

@docs MediaType


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs encoding
@docs example
@docs examples
@docs schema

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder, Value)
import Json.Encode
import OpenApi.Schema exposing (Schema)
import OpenApi.Types exposing (Encoding, Example, MediaType(..), ReferenceOr)



-- Types


{-| -}
type alias MediaType =
    OpenApi.Types.MediaType



-- Decoding


{-| -}
decode : Decoder MediaType
decode =
    OpenApi.Types.decodeMediaType


{-| -}
encode : MediaType -> Json.Encode.Value
encode =
    OpenApi.Types.encodeMediaType



-- Querying


{-| -}
schema : MediaType -> Maybe Schema
schema (MediaType mediaType) =
    mediaType.schema


{-| -}
example : MediaType -> Maybe Value
example (MediaType mediaType) =
    mediaType.example


{-| -}
examples : MediaType -> Dict String (ReferenceOr Example)
examples (MediaType mediaType) =
    mediaType.examples


{-| -}
encoding : MediaType -> Dict String Encoding
encoding (MediaType mediaType) =
    mediaType.encoding
