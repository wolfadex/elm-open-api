module OpenApi.Encoding exposing
    ( Encoding
    , decode
    , allowReserved
    , contentType
    , explode
    , headers
    , style
    )

{-| Corresponds to the [Encoding Object](https://spec.openapis.org/oas/latest.html#encoding-object) in the OpenAPI specification.


## Types

@docs Encoding


## Decoding

@docs decode


## Querying

@docs allowReserved
@docs contentType
@docs explode
@docs headers
@docs style

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import OpenApi.Header
import OpenApi.Types exposing (Encoding(..), Header, ReferenceOr)



-- Types


{-| -}
type alias Encoding =
    OpenApi.Types.Encoding



-- Decoding


{-| -}
decode : Decoder Encoding
decode =
    Json.Decode.map5
        (\contentType_ headers_ style_ explode_ allowReserved_ ->
            Encoding
                { contentType = contentType_
                , headers = headers_
                , style = style_
                , explode = explode_
                , allowReserved = allowReserved_
                }
        )
        (Json.Decode.Extra.optionalField "contentType" Json.Decode.string)
        (Json.Decode.Extra.optionalField "headers"
            (Json.Decode.dict (OpenApi.Types.decodeOr OpenApi.Header.decode))
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "style" Json.Decode.string)
        (Json.Decode.Extra.optionalField "explode" Json.Decode.bool)
        (Json.Decode.Extra.optionalField "allowReserved" Json.Decode.bool)



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
explode : Encoding -> Maybe Bool
explode (Encoding encoding) =
    encoding.explode


{-| -}
allowReserved : Encoding -> Maybe Bool
allowReserved (Encoding encoding) =
    encoding.allowReserved
