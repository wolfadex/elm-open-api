module OpenApi.Server.Variable exposing
    ( Variable
    , decode
    , default
    , description
    , enum
    )

{-| Corresponds to the [Server Variable Object](https://spec.openapis.org/oas/latest.html#server-variable-object) in the OpenAPI specification.


## Types

@docs Variable


## Decoding

@docs decode


## Querying

@docs default
@docs description
@docs enum

-}

import Json.Decode exposing (Decoder)
import Json.Decode.Extra


{-| -}
type Variable
    = Variable Internal


type alias Internal =
    { enum : List String
    , default : String
    , description : Maybe String
    }


{-| -}
decode : Decoder Variable
decode =
    Json.Decode.map3
        (\description_ default_ enum_ ->
            Variable
                { description = description_
                , default = default_
                , enum = enum_
                }
        )
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.field "default" Json.Decode.string)
        (Json.Decode.Extra.optionalField "enum" (Json.Decode.list Json.Decode.string)
            |> Json.Decode.map (Maybe.withDefault [])
        )


{-| -}
default : Variable -> String
default (Variable variable) =
    variable.default


{-| -}
enum : Variable -> List String
enum (Variable variable) =
    variable.enum


{-| -}
description : Variable -> Maybe String
description (Variable variable) =
    variable.description
