module Main exposing (..)

import Html exposing (Html, text, div)
import Html.Attributes exposing (style)
import List


(~>) : a -> b -> ( a, b )
(~>) a b =
    ( a, b )


type Msg
    = Noop


type Color
    = Blue
    | Green
    | Yellow
    | Red
    | Grey


board : List (List Color)
board =
    [ [ Blue, Blue, Green, Green, Green ]
    , [ Green, Yellow, Yellow, Red, Green ]
    , [ Red, Red, Red, Red, Yellow ]
    , [ Blue, Yellow, Green, Green, Blue ]
    , [ Blue, Blue, Green, Green, Red ]
    ]


tile : Color -> Html Msg
tile color =
    let
        emphaseStyle =
            case color of
                Blue ->
                    ("backgroundColor" ~> "royalblue")

                Green ->
                    ("backgroundColor" ~> "darkseagreen ")

                Yellow ->
                    ("backgroundColor" ~> "gold ")

                Red ->
                    ("backgroundColor" ~> "indianred")

                Grey ->
                    ("backgroundColor" ~> "grey")

        tileStyle =
            emphaseStyle
                :: [ "width" ~> "100px"
                   , "height" ~> "100px"
                   , "padding" ~> "0"
                   , "margin" ~> "1px 0 0 1px"
                   , "float" ~> "left"
                   ]
    in
        div [ style tileStyle ] []


tilesRow : List Color -> Html Msg
tilesRow tilesRow =
    div [] (List.map tile tilesRow)


main =
    let
        width =
            board
                |> List.length
                |> (*) 101
                |> toString

        layoutStyle =
            [ "padding" ~> "20px"
            , "margin" ~> "0 auto"
            , "width" ~> (width ++ "px")
            ]

        tiles =
            board
                |> List.map tilesRow
    in
        div [ style layoutStyle ]
            [ div [] tiles
            ]
