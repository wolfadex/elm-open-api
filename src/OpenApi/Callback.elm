module OpenApi.Callback exposing
    ( Callback
    , decode
    , expression
    , value
    )

{-| Corresponds to the [Callback Object](https://spec.openapis.org/oas/latest#callback-object) in the OpenAPI specification.


# Types

@docs Callback


# Decoding

@docs decode


# Querying

@docs expression
@docs value

-}

import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (Callback(..), Path, ReferenceOr)


{-| -}
type alias Callback =
    OpenApi.Types.Callback


{-| -}
decode : Decoder Callback
decode =
    OpenApi.Types.decodeCallback


{-| -}
expression : Callback -> String
expression (Callback callback) =
    callback.expression


{-| -}
value : Callback -> ReferenceOr Path
value (Callback callback) =
    callback.refOrPath
