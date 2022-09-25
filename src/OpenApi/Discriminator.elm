module OpenApi.Discriminator exposing (..)

import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (Discriminator)


type alias Discriminator =
    OpenApi.Types.Discriminator


decode : Decoder Discriminator
decode =
    OpenApi.Types.decodeDiscriminator
