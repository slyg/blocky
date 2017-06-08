module Colors exposing (Color(..), toHtmlColor)


type Color
    = Blue
    | Green
    | Yellow
    | Red
    | Grey


toHtmlColor : Color -> String
toHtmlColor c =
    case c of
        Blue ->
            "royalblue"

        Green ->
            "darkseagreen"

        Yellow ->
            "gold "

        Red ->
            "indianred"

        Grey ->
            "grey"
