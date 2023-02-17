module OpenApi.Encoding exposing
    ( Encoding
    , decode
    , encode
    , allowReserved
    , contentType
    , explode
    , headers
    , style
    )

{-| Corresponds to the [Encoding Object](https://spec.openapis.org/oas/latest.html#encoding-object) in the OpenAPI specification.


# Types

@docs Encoding


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs allowReserved
@docs contentType
@docs explode
@docs headers
@docs style

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import Json.Encode
import OpenApi.Types exposing (Encoding(..), Header, ReferenceOr)



-- Types


{-| -}
type alias Encoding =
    OpenApi.Types.Encoding



-- Decoding


{-| -}
decode : Decoder Encoding
decode =
    OpenApi.Types.decodeEncoding


{-| -}
encode : Encoding -> Json.Encode.Value
encode =
    OpenApi.Types.encodeEncoding



-- Querying


{-| -}
contentType : Encoding -> Maybe String
contentType (Encoding encoding) =
    encoding.contentType


{-| -}
headers : Encoding -> Dict String (ReferenceOr Header)
headers (Encoding encoding) =
    encoding.headers


{-| -}
style : Encoding -> Maybe String
style (Encoding encoding) =
    encoding.style


{-| -}
explode : Encoding -> Bool
explode (Encoding encoding) =
    encoding.explode


{-| -}
allowReserved : Encoding -> Bool
allowReserved (Encoding encoding) =
    encoding.allowReserved
