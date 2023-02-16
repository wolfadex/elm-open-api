module OpenApi.Xml exposing
    ( Xml
    , decode
    )

{-|

@docs Xml

@docs decode

-}

import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (Xml)


{-| -}
type alias Xml =
    OpenApi.Types.Xml


{-| -}
decode : Decoder Xml
decode =
    OpenApi.Types.decodeXml
