module OpenApi.Callback exposing (Callback, decode, expression, value)

import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (Callback(..), Path, ReferenceOr)


type alias Callback =
    OpenApi.Types.Callback


decode : Decoder Callback
decode =
    OpenApi.Types.decodeCallback



-- { expression : String
-- , refOrPath : ReferenceOr Path
-- }


expression : Callback -> String
expression (Callback callback) =
    callback.expression


value : Callback -> ReferenceOr Path
value (Callback callback) =
    callback.refOrPath
