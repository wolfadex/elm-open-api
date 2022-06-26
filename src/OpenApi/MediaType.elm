module OpenApi.MediaType exposing
    ( MediaType
    , decode
    , encoding
    , example
    , examples
    , schema
    )

{-| Corresponds to the [MediaType Object](https://spec.openapis.org/oas/latest.html#media-type-object) in the OpenAPI specification.


## Types

@docs MediaType


## Decoding

@docs decode


## Querying

@docs encoding
@docs example
@docs examples
@docs schema

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder, Value)
import Json.Decode.Extra
import OpenApi.Encoding exposing (Encoding)
import OpenApi.Example exposing (Example)
import OpenApi.Reference exposing (ReferenceOr)
import OpenApi.Schema exposing (Schema)



-- Types


{-| -}
type MediaType
    = MediaType Internal


type alias Internal =
    { schema : Maybe Schema
    , example : Maybe Value
    , examples : Dict String (ReferenceOr Example)
    , encoding : Dict String Encoding
    }



-- Decoding


{-| -}
decode : Decoder MediaType
decode =
    Json.Decode.map4
        (\schema_ example_ examples_ encoding_ ->
            MediaType
                { schema = schema_
                , example = example_
                , examples = examples_
                , encoding = encoding_
                }
        )
        (Json.Decode.Extra.optionalField "schema" OpenApi.Schema.decode)
        (Json.Decode.Extra.optionalField "example" Json.Decode.value)
        (Json.Decode.Extra.optionalField "examples"
            (Json.Decode.dict (OpenApi.Reference.decodeOr OpenApi.Example.decode))
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )
        (Json.Decode.Extra.optionalField "encoding" (Json.Decode.dict OpenApi.Encoding.decode)
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )



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
