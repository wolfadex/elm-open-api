module OpenApi.ExternalDocumentation exposing
    ( ExternalDocumentation
    , decode
    , encode
    , description
    , url
    )

{-| Corresponds to the [External Documentation Object](https://spec.openapis.org/oas/latest.html#external-documentation-object) in the OpenAPI specification.


# Types

@docs ExternalDocumentation


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs description
@docs url

-}

import Json.Decode exposing (Decoder)
import Json.Encode
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


{-| -}
encode : ExternalDocumentation -> Json.Encode.Value
encode =
    OpenApi.Types.encodeExternalDocumentation



-- Querying


{-| -}
description : ExternalDocumentation -> Maybe String
description (ExternalDocumentation externalDocs) =
    externalDocs.description


{-| -}
url : ExternalDocumentation -> String
url (ExternalDocumentation externalDocs) =
    externalDocs.url
