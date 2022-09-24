module OpenApi.Server exposing
    ( Server
    , decode
    , description
    , url
    , variables
    )

{-| Corresponds to the [Server Object](https://spec.openapis.org/oas/latest.html#server-object) in the OpenAPI specification.


## Types

@docs Server


## Decoding

@docs decode


## Querying

@docs description
@docs url
@docs variables

-}

import Dict exposing (Dict)
import Json.Decode exposing (Decoder)
import OpenApi.Server.Variable exposing (Variable)
import OpenApi.Types exposing (Server(..))



-- Types


{-| -}
type alias Server =
    OpenApi.Types.Server



-- Decoding


{-| -}
decode : Decoder Server
decode =
    OpenApi.Types.decodeServer



-- Querying


{-| -}
description : Server -> Maybe String
description (Server tag) =
    tag.description


{-| -}
url : Server -> String
url (Server tag) =
    tag.url


{-| -}
variables : Server -> Dict String Variable
variables (Server tag) =
    tag.variables
