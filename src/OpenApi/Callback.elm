module OpenApi.Callback exposing
    ( Callback
    , decode
    , expression
    , value
    )

{-|

@docs Callback
@docs decode


## Querying

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
