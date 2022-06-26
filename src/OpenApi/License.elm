module OpenApi.License exposing
    ( License
    , decode
    , identifier
    , name
    , url
    )

{-| Corresponds to the [License Object](https://spec.openapis.org/oas/latest.html#license-object) in the OpenAPI specification.


## Types

@docs License


## Decoding

@docs decode


## Querying

@docs identifier
@docs name
@docs url

-}

import Internal
import Json.Decode exposing (Decoder)
import Json.Decode.Extra



-- Types


{-| -}
type License
    = License Internal


type alias Internal =
    { name : String
    , identifierOrUrl : Maybe IdentifierOrUrl
    }


type IdentifierOrUrl
    = JustIdentifier String
    | JustUrl String



-- Decoding


{-| -}
decode : Decoder License
decode =
    Json.Decode.map2
        (\name_ identifierOrUrl_ ->
            License
                { name = name_
                , identifierOrUrl = identifierOrUrl_
                }
        )
        (Json.Decode.field "name" Json.Decode.string)
        (Internal.andThen2
            (\identifier_ url_ ->
                case ( identifier_, url_ ) of
                    ( Nothing, Nothing ) ->
                        Json.Decode.succeed Nothing

                    ( Just id, Nothing ) ->
                        Json.Decode.succeed (Just (JustIdentifier id))

                    ( Nothing, Just u ) ->
                        Json.Decode.succeed (Just (JustUrl u))

                    ( Just _, Just _ ) ->
                        Json.Decode.fail "A license is not allowed to have both an identifier and a url"
            )
            (Json.Decode.Extra.optionalField "identifier" Json.Decode.string)
            (Json.Decode.Extra.optionalField "url" Json.Decode.string)
        )



-- Querying


{-| -}
name : License -> String
name (License license) =
    license.name


{-| -}
identifier : License -> Maybe String
identifier (License license) =
    case license.identifierOrUrl of
        Just (JustIdentifier i) ->
            Just i

        _ ->
            Nothing


{-| -}
url : License -> Maybe String
url (License license) =
    case license.identifierOrUrl of
        Just (JustUrl u) ->
            Just u

        _ ->
            Nothing
