module Internal exposing
    ( andThen2
    , andThen3
    , maybeEncodeField
    , maybeEncodeListField
    )

import Json.Decode exposing (Decoder)
import Json.Encode


andThen2 : (a -> b -> Decoder c) -> Decoder a -> Decoder b -> Decoder c
andThen2 f decoderA decoderB =
    Json.Decode.map2 Tuple.pair decoderA decoderB
        |> Json.Decode.andThen (\( a, b ) -> f a b)


andThen3 : (a -> b -> c -> Decoder d) -> Decoder a -> Decoder b -> Decoder c -> Decoder d
andThen3 f decoderA decoderB decoderC =
    Json.Decode.map3 (\a b c -> ( a, b, c )) decoderA decoderB decoderC
        |> Json.Decode.andThen (\( a, b, c ) -> f a b c)


type Value a
    = Present a
    | Absent
    | Null


maybeEncodeField : ( String, a -> Json.Encode.Value ) -> Maybe a -> Maybe ( String, Json.Encode.Value )
maybeEncodeField ( name, encoder ) maybeVal =
    case maybeVal of
        Nothing ->
            Nothing

        Just val ->
            Just ( name, encoder val )


maybeEncodeListField : ( String, a -> Json.Encode.Value ) -> List a -> Maybe ( String, Json.Encode.Value )
maybeEncodeListField ( name, encoder ) listVal =
    case listVal of
        [] ->
            Nothing

        _ ->
            Just ( name, Json.Encode.list encoder listVal )
