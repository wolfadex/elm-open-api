module OpenApi.Schema exposing
    ( Schema
    , decode
    , encode
    , get
    )

{-| Corresponds to the [Schema Object](https://spec.openapis.org/oas/latest#schema-object) in the OpenAPI specification which in turn uses the [JSON Schema Specification](https://json-schema.org/specification.html).

Since this is its own separate specification, the package [json-tools/json-schema](https://package.elm-lang.org/packages/json-tools/json-schema/latest/) is used. Please see their docs for accessible values

Because this modules is a wrapper around a separate package and its types, its interface is slightly different.
We still keep the opaque type [Schema](#Schema) and matching [decode](#decode). The primary differnce is around querying.
Instead of providing querying functions for the JSON Schema spec, I provide a singular [get](#get) function for accessing
the wrapped [json-tools/json-schema Json.Schema.Definitions.Schema](https://package.elm-lang.org/packages/json-tools/json-schema/latest/Json-Schema-Definitions#Schema) value.

This is a little unusal compared to the rest of the package but the hope is that this allows for easier migration to a fully compliant JSON Schema package in a future release.


# Types

@docs Schema


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs get

-}

import Json.Decode exposing (Decoder)
import Json.Encode
import Json.Schema.Definitions
import OpenApi.Types exposing (Schema(..))


{-| -}
type alias Schema =
    OpenApi.Types.Schema


{-| -}
decode : Decoder Schema
decode =
    OpenApi.Types.decodeSchema


{-| -}
encode : Schema -> Json.Encode.Value
encode =
    OpenApi.Types.encodeSchema


{-| Given the above [Schema](#Schema) returns a [json-tools/json-schema Json.Schema.Definitions.Schema](https://package.elm-lang.org/packages/json-tools/json-schema/latest/Json-Schema-Definitions#Schema)
-}
get : Schema -> Json.Schema.Definitions.Schema
get (Schema schema_) =
    schema_
