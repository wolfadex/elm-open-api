module OpenApi.Header exposing
    ( Header
    , decode
    , encode
    , allowEmptyValue
    , content
    , deprecated
    , description
    , example
    , examples
    , explode
    , required
    , schema
    , style
    )

{-| Corresponds to the [Header Object](https://spec.openapis.org/oas/latest#header-object) in the OpenAPI specification.


# Types

@docs Header


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs allowEmptyValue
@docs content
@docs deprecated
@docs description
@docs example
@docs examples
@docs explode
@docs required
@docs schema
@docs style

-}

import Dict exposing (Dict)
import Json.Decode
import Json.Encode
import OpenApi.Example exposing (Example)
import OpenApi.Types exposing (Header(..), MediaType, ReferenceOr, Schema)


{-| -}
type alias Header =
    OpenApi.Types.Header


{-| -}
decode : Json.Decode.Decoder Header
decode =
    OpenApi.Types.decodeHeader


{-| -}
encode : Header -> Json.Encode.Value
encode =
    OpenApi.Types.encodeHeader


{-| -}
style : Header -> Maybe String
style (Header header) =
    header.style


{-| -}
explode : Header -> Bool
explode (Header header) =
    header.explode


{-| -}
description : Header -> Maybe String
description (Header header) =
    header.description


{-| -}
required : Header -> Bool
required (Header header) =
    header.required


{-| -}
deprecated : Header -> Bool
deprecated (Header header) =
    header.deprecated


{-| -}
allowEmptyValue : Header -> Bool
allowEmptyValue (Header header) =
    header.allowEmptyValue


{-| -}
schema : Header -> Maybe Schema
schema (Header header) =
    header.schema


{-| -}
content : Header -> Dict String MediaType
content (Header header) =
    header.content


{-| -}
example : Header -> Maybe Json.Encode.Value
example (Header header) =
    header.example


{-| -}
examples : Header -> Dict String (ReferenceOr Example)
examples (Header header) =
    header.examples
