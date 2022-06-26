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
import Json.Decode.Extra
import OpenApi.Server.Variable exposing (Variable)



-- Types


{-| -}
type Server
    = Server Internal


type alias Internal =
    { description : Maybe String
    , url : String
    , variables : Dict String Variable
    }



-- Decoding


{-| -}
decode : Decoder Server
decode =
    Json.Decode.map3
        (\description_ url_ variables_ ->
            Server
                { description = description_
                , url = url_
                , variables = variables_
                }
        )
        (Json.Decode.Extra.optionalField "description" Json.Decode.string)
        (Json.Decode.field "url" Json.Decode.string)
        (Json.Decode.Extra.optionalField "variables" (Json.Decode.dict OpenApi.Server.Variable.decode)
            |> Json.Decode.map (Maybe.withDefault Dict.empty)
        )



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
