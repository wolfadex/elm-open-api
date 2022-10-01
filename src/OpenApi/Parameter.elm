module OpenApi.Parameter exposing
    ( Location
    , Parameter
    , allowEmptyValue
    , allowReserved
    , content
    , decode
    , deprecated
    , description
    , example
    , examples
    , explode
    , in_
    , location
    , name
    , required
    , schema
    , style
    )

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)
import OpenApi.Types exposing (Example, Location(..), MediaType, Parameter(..), ReferenceOr, Schema)


type alias Parameter =
    OpenApi.Types.Parameter


type alias Location =
    OpenApi.Types.Location


decode : Decoder Parameter
decode =
    OpenApi.Types.decodeParameter


name : Parameter -> String
name (Parameter parameter_) =
    parameter_.name


location : Parameter -> Location
location (Parameter parameter_) =
    parameter_.in_


in_ : Parameter -> String
in_ (Parameter parameter_) =
    case parameter_.in_ of
        LocQuery _ ->
            "query"

        LocHeader _ ->
            "header"

        LocPath _ ->
            "path"

        LocCookie _ ->
            "cookie"


style : Parameter -> String
style (Parameter parameter_) =
    case parameter_.in_ of
        LocQuery details ->
            details.style

        LocHeader details ->
            details.style

        LocPath details ->
            details.style

        LocCookie details ->
            details.style


explode : Parameter -> Bool
explode (Parameter parameter_) =
    case parameter_.in_ of
        LocQuery details ->
            details.explode

        LocHeader details ->
            details.explode

        LocPath details ->
            details.explode

        LocCookie details ->
            details.explode


allowReserved : Parameter -> Maybe Bool
allowReserved (Parameter parameter_) =
    case parameter_.in_ of
        LocQuery details ->
            Just details.allowReserved

        LocHeader _ ->
            Nothing

        LocPath _ ->
            Nothing

        LocCookie _ ->
            Nothing


description : Parameter -> Maybe String
description (Parameter parameter_) =
    parameter_.description


required : Parameter -> Bool
required (Parameter parameter_) =
    parameter_.required


deprecated : Parameter -> Bool
deprecated (Parameter parameter_) =
    parameter_.deprecated


allowEmptyValue : Parameter -> Bool
allowEmptyValue (Parameter parameter_) =
    parameter_.allowEmptyValue


schema : Parameter -> Maybe Schema
schema (Parameter parameter_) =
    parameter_.schema


content : Parameter -> Dict String MediaType
content (Parameter parameter_) =
    parameter_.content


example : Parameter -> Maybe Value
example (Parameter parameter_) =
    parameter_.example


examples : Parameter -> Dict String (ReferenceOr Example)
examples (Parameter parameter_) =
    parameter_.examples
