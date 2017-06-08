module Board exposing (tile, tilesRow, board)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Colors exposing (Color(..), toHtmlColor)
import Types exposing (Msg(..))


(~>) : a -> b -> ( a, b )
(~>) a b =
    ( a, b )


tile : Int -> Int -> Color -> Html Msg
tile i j color =
    let
        tileDimension =
            "100px"

        tileStyle =
            [ "backgroundColor" ~> toHtmlColor color
            , "width" ~> tileDimension
            , "height" ~> tileDimension
            , "padding" ~> "0"
            , "margin" ~> "1px 0 0 1px"
            , "float" ~> "left"
            ]

        coords =
            (toString i) ++ (toString j)
    in
        div
            [ style tileStyle
            , onClick (Touch ( i, j ))
            ]
            [ text coords ]


tilesRow : Int -> List Color -> Html Msg
tilesRow i tilesRow =
    div [] (List.indexedMap (tile i) tilesRow)


board : List (List Color) -> Html Msg
board data =
    let
        width =
            data
                |> List.length
                |> (*) 101
                |> toString

        layoutStyle =
            [ "padding" ~> "20px"
            , "margin" ~> "0 auto"
            , "width" ~> (width ++ "px")
            ]

        tiles =
            data
                |> List.indexedMap tilesRow
    in
        div [ style layoutStyle ]
            [ div [] tiles
            ]
