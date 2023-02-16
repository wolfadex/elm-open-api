module OpenApi.Schema exposing
    ( Schema
    , decode
    , get
    )

{-|

@docs Schema
@docs decode


## Querying

@docs get

-}

import Json.Decode exposing (Decoder, Value)
import Json.Schema.Definitions
import OpenApi.Types exposing (Discriminator, ExternalDocumentation, Schema(..), Xml)


{-| -}
type alias Schema =
    OpenApi.Types.Schema


{-| -}
decode : Decoder Schema
decode =
    OpenApi.Types.decodeSchema


{-| -}
get : Schema -> Json.Schema.Definitions.Schema
get (Schema schema_) =
    schema_
