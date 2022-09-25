module Internal exposing
    ( andThen2
    , andThen3
    )

import Json.Decode exposing (Decoder)


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
