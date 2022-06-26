module OpenApi.Tag exposing
    ( Tag
    , decode
    , description
    , externalDocs
    , name
    )

{-| Corresponds to the [Tag Object](https://spec.openapis.org/oas/latest.html#tag-object) in the OpenAPI specification.


## Types

@docs Tag


## Decoding

@docs decode


## Querying

@docs description
@docs externalDocs
@docs name

-}

import Json.Decode exposing (Decoder)
import Json.Decode.Extra
import OpenApi.ExternalDocumentation exposing (ExternalDocumentation)



-- Types


{-| -}
type Tag
    = Tag Internal


type alias Internal =
    { description : Maybe String
    , name : String
    , externalDocs : Maybe ExternalDocumentation
    }



-- Decoding


{-| -}
decode : Decoder Tag
decode =
    Json.Decode.map3
        (\description_ name_ externalDocs_ ->
            Tag
                { description = description_
                , name = name_
                , externalDocs = externalDocs_
                }
        )
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.Extra.optionalField "externalDocs" OpenApi.ExternalDocumentation.decode)



-- Querying


{-| -}
description : Tag -> Maybe String
description (Tag tag) =
    tag.description


{-| -}
name : Tag -> String
name (Tag tag) =
    tag.name


{-| -}
externalDocs : Tag -> Maybe ExternalDocumentation
externalDocs (Tag tag) =
    tag.externalDocs
