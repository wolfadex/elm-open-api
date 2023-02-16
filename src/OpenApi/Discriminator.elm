module OpenApi.Discriminator exposing
    ( Discriminator
    , decode
    , propertyName
    , mapping
    )

{-| Corresponds to the [Discriminator Object](https://spec.openapis.org/oas/latest#discriminator-object) in the OpenAPI specification.


# Types

@docs Discriminator


# Decoding

@docs decode


# Querying

@docs propertyName
@docs mapping

-}

import Dict
import Json.Decode
import OpenApi.Types


{-| -}
type alias Discriminator =
    OpenApi.Types.Discriminator


{-| -}
decode : Json.Decode.Decoder Discriminator
decode =
    OpenApi.Types.decodeDiscriminator


{-| -}
propertyName : Discriminator -> String
propertyName (OpenApi.Types.Discriminator discriminator) =
    discriminator.propertyName


{-| -}
mapping : Discriminator -> Dict.Dict String String
mapping (OpenApi.Types.Discriminator discriminator) =
    discriminator.mapping
