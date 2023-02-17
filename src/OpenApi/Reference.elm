module OpenApi.Reference exposing
    ( Reference
    , ReferenceOr
    , decode
    , encode
    , description
    , ref
    , summary
    )

{-| Corresponds to the [Reference Object](https://spec.openapis.org/oas/latest#reference-object) in the OpenAPI specification.


# Types

@docs Reference
@docs ReferenceOr


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs description
@docs ref
@docs summary

-}

import Json.Decode exposing (Decoder)
import Json.Encode
import OpenApi.Types exposing (Reference(..), ReferenceOr(..))


{-| -}
type alias Reference =
    OpenApi.Types.Reference


{-| Many values in the OpenAPI Specification may have concrete values, or they may have a [Reference](#Reference) to a value elsewhere.
This type is a wrapper around the possibility of the value being either of these 2.
-}
type alias ReferenceOr a =
    OpenApi.Types.ReferenceOr a


{-| -}
decode : Decoder Reference
decode =
    OpenApi.Types.decodeReference


{-| -}
encode : Reference -> Json.Encode.Value
encode =
    OpenApi.Types.encodeReference


{-| -}
description : Reference -> Maybe String
description (Reference reference) =
    reference.description


{-| The URI location of the actual value
-}
ref : Reference -> String
ref (Reference reference) =
    reference.ref


{-| -}
summary : Reference -> Maybe String
summary (Reference reference) =
    reference.summary
