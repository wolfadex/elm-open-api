module OpenApi.Callback exposing
    ( Callback
    , decode
    , encode
    , expression
    , value
    )

{-| Corresponds to the [Callback Object](https://spec.openapis.org/oas/latest#callback-object) in the OpenAPI specification.


# Types

@docs Callback


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs expression
@docs value

-}

import Json.Decode exposing (Decoder)
import Json.Encode
import OpenApi.Types exposing (Callback(..), Path, ReferenceOr)


{-| -}
type alias Callback =
    OpenApi.Types.Callback


{-| -}
decode : Decoder Callback
decode =
    OpenApi.Types.decodeCallback


{-| -}
encode : Callback -> Json.Encode.Value
encode =
    OpenApi.Types.encodeCallback


{-| -}
expression : Callback -> String
expression (Callback callback) =
    callback.expression


{-| -}
value : Callback -> ReferenceOr Path
value (Callback callback) =
    callback.refOrPath
