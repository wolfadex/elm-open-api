module OpenApi.Discriminator exposing
    ( Discriminator
    , decode
    , encode
    , propertyName
    , mapping
    )

{-| Corresponds to the [Discriminator Object](https://spec.openapis.org/oas/latest#discriminator-object) in the OpenAPI specification.


# Types

@docs Discriminator


# Decoding / Encoding

@docs decode
@docs encode


# Querying

@docs propertyName
@docs mapping

-}

import Dict
import Json.Decode
import Json.Encode
import OpenApi.Types


{-| -}
type alias Discriminator =
    OpenApi.Types.Discriminator


{-| -}
decode : Json.Decode.Decoder Discriminator
decode =
    OpenApi.Types.decodeDiscriminator


{-| -}
encode : Discriminator -> Json.Encode.Value
encode =
    OpenApi.Types.encodeDiscriminator


{-| -}
propertyName : Discriminator -> String
propertyName (OpenApi.Types.Discriminator discriminator) =
    discriminator.propertyName


{-| -}
mapping : Discriminator -> Dict.Dict String String
mapping (OpenApi.Types.Discriminator discriminator) =
    discriminator.mapping
