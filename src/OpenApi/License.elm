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

import Json.Decode exposing (Decoder)
import Json.Decode.Extra



-- Types


{-| -}
type License
    = License LicenseInternal


type alias LicenseInternal =
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
        (andThen2
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



-- Helpers


andThen2 : (a -> b -> Decoder c) -> Decoder a -> Decoder b -> Decoder c
andThen2 f decoderA decoderB =
    Json.Decode.map2 Tuple.pair decoderA decoderB
        |> Json.Decode.andThen (\( a, b ) -> f a b)



-- andThen3 : (a -> b -> c -> Decoder d) -> Decoder a -> Decoder b -> Decoder c -> Decoder d
-- andThen3 f decoderA decoderB decoderC =
--     Json.Decode.map3 (\a b c -> ( a, b, c )) decoderA decoderB decoderC
--         |> Json.Decode.andThen (\( a, b, c ) -> f a b c)
