module OpenApi.Header exposing
    ( Header
    , allowEmptyValue
    , content
    , decode
    , deprecated
    , description
    , example
    , examples
    , explode
    , required
    , schema
    , style
    )

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import OpenApi.Example exposing (Example)
import OpenApi.Types exposing (Header(..), MediaType, ReferenceOr, Schema)


type alias Header =
    OpenApi.Types.Header


decode : Decoder Header
decode =
    OpenApi.Types.decodeHeader


style : Header -> Maybe String
style (Header header) =
    header.style


explode : Header -> Bool
explode (Header header) =
    header.explode


description : Header -> Maybe String
description (Header header) =
    header.description


required : Header -> Bool
required (Header header) =
    header.required


deprecated : Header -> Bool
deprecated (Header header) =
    header.deprecated


allowEmptyValue : Header -> Bool
allowEmptyValue (Header header) =
    header.allowEmptyValue


schema : Header -> Maybe Schema
schema (Header header) =
    header.schema


content : Header -> Dict String MediaType
content (Header header) =
    header.content


example : Header -> String
example (Header header) =
    header.example


examples : Header -> Dict String (ReferenceOr Example)
examples (Header header) =
    header.examples
