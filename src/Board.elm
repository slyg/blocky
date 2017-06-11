module Board exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Array exposing (Array)
import Set exposing (Set)
import Maybe exposing (andThen)
import Types exposing (..)


(~>) : a -> b -> ( a, b )
(~>) a b =
    ( a, b )


toHtmlColor : Color -> String
toHtmlColor c =
    case c of
        Blue ->
            "royalblue"

        Green ->
            "darkseagreen"

        Yellow ->
            "gold"

        Red ->
            "indianred"

        Grey ->
            "lightgrey"


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
            , "cursor" ~> "pointer"
            , "transition" ~> "background-color .1s ease"
            ]
    in
        div
            [ style tileStyle
            , onClick (Touch ( i, j ))
            ]
            []


tilesRow : Int -> Array Color -> Html Msg
tilesRow i tilesRow =
    div [] (tilesRow |> Array.indexedMap (tile i) |> Array.toList)


view : Board -> Html Msg
view data =
    let
        ( rowNum, colNum ) =
            dimensions data

        width =
            colNum
                |> (*) 101
                |> toString

        height =
            rowNum
                |> (*) 101
                |> toString

        layoutStyle =
            [ "margin" ~> "0 auto"
            , "width" ~> (width ++ "px")
            , "height" ~> (height ++ "px")
            , "transform" ~> "perspective(1010px) rotateX(60deg) rotateZ(90deg)"
            ]

        tiles =
            data
                |> Array.indexedMap tilesRow
                |> Array.toList
    in
        div [ style layoutStyle ]
            [ div [] tiles
            ]


get : Coord -> Board -> Maybe Color
get coord board =
    let
        ( i, j ) =
            coord
    in
        board
            |> (Array.get i)
            |> andThen (Array.get j)


update : Board -> Color -> Coord -> Board
update board color ( i, j ) =
    case Array.get i board of
        Nothing ->
            board

        Just oldRow ->
            let
                newRow =
                    Array.set j color oldRow
            in
                Array.set i newRow board


dimensions : Board -> ( Int, Int )
dimensions board =
    ( Array.length board, Array.foldl (Array.length >> max) 0 board )


getSiblingCoordinates : Coord -> Direction -> Coord
getSiblingCoordinates ( i, j ) direction =
    case direction of
        Top ->
            ( i - 1, j )

        Right ->
            ( i, j + 1 )

        Bottom ->
            ( i + 1, j )

        Left ->
            ( i, j - 1 )


getAdjacentKins : Board -> Coord -> List Coord
getAdjacentKins board coord =
    let
        getColor : Coord -> Maybe Color
        getColor ( i, j ) =
            board
                |> Array.get i
                |> andThen (Array.get j)

        targetColor : Maybe Color
        targetColor =
            getColor coord

        ( maxI, maxJ ) =
            dimensions board

        directions =
            [ Top, Right, Bottom, Left ]

        siblings =
            directions
                |> List.map (getSiblingCoordinates coord)
                |> List.filter (\( i, j ) -> i < maxI && j < maxJ && i > -1 && j > -1)
                |> List.filter (\coord -> (getColor coord) == targetColor)
    in
        siblings



-- Use BFS (Breadth First Search) to find same color siblings, named kins here


searchKinsRec : Board -> Coord -> List Coord -> Set Coord -> List Coord
searchKinsRec board coord queue visited =
    let
        kins =
            getAdjacentKins board coord

        nextUnVisitedKin =
            kins
                |> List.filter (\coord -> not (Set.member coord visited))
                |> List.head
    in
        case nextUnVisitedKin of
            Nothing ->
                case queue of
                    [] ->
                        Set.toList visited

                    [ s ] ->
                        searchKinsRec board s [] visited

                    s :: xs ->
                        searchKinsRec board s xs visited

            Just unVisitedKin ->
                let
                    nextQueue =
                        unVisitedKin :: queue

                    nextVisited =
                        Set.insert unVisitedKin visited
                in
                    searchKinsRec board unVisitedKin nextQueue nextVisited


searchKins : Board -> Coord -> List Coord
searchKins board coord =
    searchKinsRec board coord [ coord ] (Set.singleton coord)


sortColorsInRowRec : List Color -> List Color -> List Color
sortColorsInRowRec rowLeft rowRight =
    case rowLeft of
        [] ->
            List.reverse rowRight

        x :: xs ->
            let
                newRowRight =
                    case x of
                        Grey ->
                            List.append rowRight [ x ]

                        _ ->
                            x :: rowRight
            in
                sortColorsInRowRec xs newRowRight


sortColorsInRow : Array Color -> Array Color
sortColorsInRow row =
    sortColorsInRowRec (Array.toList row) []
        |> Array.fromList


fallRightColors : Board -> Board
fallRightColors board =
    board
        |> Array.map sortColorsInRow
