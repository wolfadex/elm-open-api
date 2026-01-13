module Result.Extra exposing (combineMap)

{-|

@docs combineMap

-}


{-| Map a function producing results on a list
and combine those into a single result (holding a list).
Also known as `traverse` on lists.

    combineMap f xs == combine (List.map f xs)

-}
combineMap : (a -> Result x b) -> List a -> Result x (List b)
combineMap f ls =
    combineMapHelp f ls []


combineMapHelp : (a -> Result x b) -> List a -> List b -> Result x (List b)
combineMapHelp f list acc =
    case list of
        head :: tail ->
            case f head of
                Ok a ->
                    combineMapHelp f tail (a :: acc)

                Err x ->
                    Err x

        [] ->
            Ok (List.reverse acc)
