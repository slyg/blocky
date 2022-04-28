module Board exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Array exposing (Array)
import Set exposing (Set)
import Maybe exposing (andThen)
import Types exposing (..)


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

        tileAttributes =
            [ (style "backgroundColor" (toHtmlColor color))
            , (style "width" tileDimension)
            , (style "height" tileDimension)
            , (style "padding" "0")
            , (style "margin" "1px 0 0 1px")
            , (style "float" "left")
            , (style "cursor" "pointer")
            , (style "transition" "background-color .1s ease")
            , onClick (Touch ( i, j ))
            ]
    in
        div
            tileAttributes
            []


tilesRow : Int -> Array Color -> Html Msg
tilesRow i tr =
    div [] (tr |> Array.indexedMap (tile i) |> Array.toList)


view : Board -> Html Msg
view data =
    let
        ( rowNum, colNum ) =
            dimensions data

        width =
            colNum
                |> (*) 101
                |> String.fromInt

        height =
            rowNum
                |> (*) 101
                |> String.fromInt

        layoutStyle =
            [ (style "margin" "0 auto")
            , (style "width" (width ++ "px"))
            , (style "height" (height ++ "px"))
            , (style "transform" "perspective(1010px) rotateX(60deg) rotateZ(90deg)")
            ]

        tiles =
            data
                |> Array.indexedMap tilesRow
                |> Array.toList
    in
        div layoutStyle
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
                |> List.filter (\c -> (getColor c) == targetColor)
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
                |> List.filter (\c -> not (Set.member c visited))
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
