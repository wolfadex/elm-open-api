module OpenApi.ExternalDocumentation exposing
    ( ExternalDocumentation
    , decode
    , description
    , url
    )

{-| Corresponds to the [External Documentation Object](https://spec.openapis.org/oas/latest.html#external-documentation-object) in the OpenAPI specification.


# Types

@docs ExternalDocumentation


# Decoding

@docs decode


# Querying

@docs description
@docs url

-}

import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (ExternalDocumentation(..))



-- Types


{-| -}
type alias ExternalDocumentation =
    OpenApi.Types.ExternalDocumentation



-- Decoding


{-| -}
decode : Decoder ExternalDocumentation
decode =
    OpenApi.Types.decodeExternalDocumentation



-- Querying


{-| -}
description : ExternalDocumentation -> Maybe String
description (ExternalDocumentation externalDocs) =
    externalDocs.description


{-| -}
url : ExternalDocumentation -> String
url (ExternalDocumentation externalDocs) =
    externalDocs.url
