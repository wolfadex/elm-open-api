module OpenApi.ExternalDocumentation exposing
    ( ExternalDocumentation
    , decode
    , description
    , url
    )

{-| Corresponds to the [External Documentation Object](https://spec.openapis.org/oas/latest.html#external-documentation-object) in the OpenAPI specification.


## Types

@docs ExternalDocumentation


## Decoding

@docs decode


## Querying

@docs description
@docs url

-}

import Json.Decode exposing (Decoder)
import Json.Decode.Extra



-- Types


{-| -}
type ExternalDocumentation
    = ExternalDocumentation Internal


type alias Internal =
    { description : Maybe String
    , url : String
    }



-- Decoding


{-| -}
decode : Decoder ExternalDocumentation
decode =
    Json.Decode.map2
        (\description_ url_ ->
            ExternalDocumentation
                { description = description_
                , url = url_
                }
        )
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.field "url" Json.Decode.string)



-- Querying


{-| -}
description : ExternalDocumentation -> Maybe String
description (ExternalDocumentation externalDocs) =
    externalDocs.description


{-| -}
url : ExternalDocumentation -> String
url (ExternalDocumentation externalDocs) =
    externalDocs.url
