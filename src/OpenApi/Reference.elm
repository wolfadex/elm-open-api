module OpenApi.Reference exposing
    ( Reference
    , ReferenceOr
    , decode
    , description
    , ref
    , summary
    )

{-|

@docs Reference
@docs ReferenceOr

@docs decode


## Querying

@docs description
@docs ref
@docs summary

-}

import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (Reference(..), ReferenceOr(..))


{-| -}
type alias Reference =
    OpenApi.Types.Reference


{-| -}
type alias ReferenceOr a =
    OpenApi.Types.ReferenceOr a


{-| -}
decode : Decoder Reference
decode =
    OpenApi.Types.decodeReference


{-| -}
description : Reference -> Maybe String
description (Reference reference) =
    reference.description


{-| -}
ref : Reference -> String
ref (Reference reference) =
    reference.ref


{-| -}
summary : Reference -> Maybe String
summary (Reference reference) =
    reference.summary
