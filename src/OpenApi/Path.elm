module OpenApi.Path exposing
    ( Path
    , decode
    , delete
    , description
    , get
    , head
    , options
    , parameters
    , patch
    , post
    , put
    , servers
    , summary
    , trace
    )

{-| Corresponds to the [Path Item Object](https://spec.openapis.org/oas/latest#path-item-object) in the OpenAPI specification.


# Types

@docs Path


# Decoding

@docs decode


# Querying

@docs delete
@docs description
@docs get
@docs head
@docs options
@docs parameters
@docs patch
@docs post
@docs put
@docs servers
@docs summary
@docs trace

-}

import Json.Decode exposing (Decoder)
import OpenApi.Types exposing (Operation, Parameter, Path(..), ReferenceOr, Server)


{-| -}
type alias Path =
    OpenApi.Types.Path


{-| -}
decode : Decoder Path
decode =
    OpenApi.Types.decodePath


{-| -}
summary : Path -> Maybe String
summary (Path path_) =
    path_.summary


{-| -}
description : Path -> Maybe String
description (Path path_) =
    path_.description


{-| -}
get : Path -> Maybe Operation
get (Path path_) =
    path_.get


{-| -}
put : Path -> Maybe Operation
put (Path path_) =
    path_.put


{-| -}
post : Path -> Maybe Operation
post (Path path_) =
    path_.post


{-| -}
delete : Path -> Maybe Operation
delete (Path path_) =
    path_.delete


{-| -}
options : Path -> Maybe Operation
options (Path path_) =
    path_.options


{-| -}
head : Path -> Maybe Operation
head (Path path_) =
    path_.head


{-| -}
patch : Path -> Maybe Operation
patch (Path path_) =
    path_.patch


{-| -}
trace : Path -> Maybe Operation
trace (Path path_) =
    path_.trace


{-| -}
servers : Path -> List Server
servers (Path path_) =
    path_.servers


{-| -}
parameters : Path -> List (ReferenceOr Parameter)
parameters (Path path_) =
    path_.parameters
