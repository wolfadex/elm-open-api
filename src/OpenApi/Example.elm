module OpenApi.Example exposing
    ( Example
    , decode
    , description
    , externalValue
    , summary
    , value
    )

{-| Corresponds to the [Example Object](https://spec.openapis.org/oas/latest.html#example-object) in the OpenAPI specification.


## Types

@docs Example


## Decoding

@docs decode


## Querying

@docs description
@docs externalValue
@docs summary
@docs value

-}

import Json.Decode exposing (Decoder, Value)
import Json.Decode.Extra



-- Types


{-| -}
type Example
    = Example Internal


type alias Internal =
    { summary : Maybe String
    , description : Maybe String
    , value : Maybe Value
    , externalValue : Maybe String
    }



-- Decoding


{-| -}
decode : Decoder Example
decode =
    Json.Decode.map4
        (\summary_ description_ value_ externalValue_ ->
            Example
                { summary = summary_
                , description = description_
                , value = value_
                , externalValue = externalValue_
                }
        )
        (Json.Decode.Extra.optionalField "summary" Json.Decode.string)
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.Extra.optionalField "value" Json.Decode.value)
        (Json.Decode.Extra.optionalField "externalValue" Json.Decode.string)



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
value : Example -> Maybe Value
value (Example example) =
    example.value


{-| -}
externalValue : Example -> Maybe String
externalValue (Example example) =
    example.externalValue
