module OpenApi.Header exposing
    ( Header
    , decode
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

{-|

@docs Header
@docs decode


## Querying

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
import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)
import OpenApi.Example exposing (Example)
import OpenApi.Types exposing (Header(..), MediaType, ReferenceOr, Schema)


{-| -}
type alias Header =
    OpenApi.Types.Header


{-| -}
decode : Decoder Header
decode =
    OpenApi.Types.decodeHeader


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
example : Header -> Maybe Value
example (Header header) =
    header.example


{-| -}
examples : Header -> Dict String (ReferenceOr Example)
examples (Header header) =
    header.examples
