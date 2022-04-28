module BoardTest exposing (..)

import Array exposing (Array)
import Board exposing (..)
import Expect exposing (equal)
import Maybe exposing (..)
import Test exposing (..)
import Types exposing (..)


suite : Test
suite =
    describe "truc"
        [ describe "Board.toHtmlColor"
            [ test "Blue works" <|
                \() ->
                    Board.toHtmlColor Blue
                        |> equal "royalblue"
            , test "Green works" <|
                \() ->
                    Board.toHtmlColor Green
                        |> equal "darkseagreen"
            , test "Yellow works" <|
                \() ->
                    Board.toHtmlColor Yellow
                        |> equal "gold"
            , test "Red works" <|
                \() ->
                    Board.toHtmlColor Red
                        |> equal "indianred"
            , test "Grey works" <|
                \() ->
                    Board.toHtmlColor Grey
                        |> equal "lightgrey"
            ]
        , describe "Board.get"
            [ test "Returns Just color when coordinates are inside board" <|
                \() ->
                    testBoard
                        |> Board.get ( 0, 0 )
                        |> equal (Just Blue)
            , test "Returns Nothing when coordinates are outside board" <|
                \() ->
                    testBoard
                        |> Board.get ( 3, 0 )
                        |> equal Nothing
            ]
        , describe "Board.update"
            [ test "Returns the updated board when coordinates are inside board" <|
                \() ->
                    let
                        expectedBoard =
                            Array.fromList
                                [ Array.fromList [ Blue, Blue, Red ]
                                , Array.fromList [ Blue, Grey, Red ]
                                ]
                    in
                        Board.update testBoard Grey ( 1, 1 )
                            |> equal expectedBoard
            , test "Returns the board when coordinates are outside board" <|
                \() ->
                    Board.update testBoard Grey ( 3, 1 )
                        |> equal testBoard
            ]
        , describe "Board.dimensions"
            [ test "Returns the board dimensions" <|
                \() ->
                    Board.dimensions testBoard
                        |> equal ( 2, 3 )
            , test "Returns the board max dimensions" <|
                \() ->
                    let
                        nonSquaredBoard =
                            Array.fromList
                                [ Array.fromList [ Blue, Blue, Red ]
                                , Array.fromList [ Blue, Red ]
                                , Array.fromList [ Blue ]
                                ]
                    in
                        Board.dimensions nonSquaredBoard
                            |> equal ( 3, 3 )
            ]
        , describe "Board.getSiblingCoordinates"
            [ describe "returns siblings coordinates of a given coord and direction"
                [ test "Top works" <|
                    \() ->
                        Board.getSiblingCoordinates ( 0, 0 ) Top
                            |> equal ( -1, 0 )
                , test "Right works" <|
                    \() ->
                        Board.getSiblingCoordinates ( 0, 0 ) Right
                            |> equal ( 0, 1 )
                , test "Bottom works" <|
                    \() ->
                        Board.getSiblingCoordinates ( 0, 0 ) Bottom
                            |> equal ( 1, 0 )
                , test "Left works" <|
                    \() ->
                        Board.getSiblingCoordinates ( 0, 0 ) Left
                            |> equal ( 0, -1 )
                ]
            ]
        , describe "Board.getAdjacentKins (BDD)"
            [ test "returns a list of coordinates of siblings of the same color, named kins" <|
                \() ->
                    let
                        expectedMatches =
                            [ ( 0, 1 ), ( 1, 0 ) ]
                    in
                        Board.getAdjacentKins testBoard ( 0, 0 )
                            |> List.map (\color -> List.member color expectedMatches)
                            |> List.foldl (&&) True
                            |> equal True
            ]
        , describe "Board.searchKins (BDD)"
            [ test "returns a list of all connected siblings of the same color, named kins" <|
                \() ->
                    let
                        expectedMatches =
                            [ ( 0, 0 )
                            , ( 1, 0 )
                            , ( 1, 1 )
                            , ( 2, 1 )
                            , ( 2, 5 )
                            , ( 3, 1 )
                            , ( 3, 5 )
                            , ( 4, 0 )
                            , ( 4, 1 )
                            , ( 4, 2 )
                            , ( 4, 3 )
                            , ( 4, 4 )
                            , ( 4, 5 )
                            , ( 5, 1 )
                            , ( 5, 2 )
                            , ( 5, 5 )
                            , ( 6, 3 )
                            , ( 6, 4 )
                            , ( 6, 5 )
                            ]
                    in
                        Board.searchKins complexTestBoard ( 0, 0 )
                            |> List.map (\color -> List.member color expectedMatches)
                            |> List.foldl (&&) True
                            |> equal True
            ]
        , describe "Board.sortColorsInRow"
            [ test "In a List of colors, gathers all colors different from Grey towards tail" <|
                \() ->
                    let
                        colorsList =
                            Array.fromList [ Red, Grey, Blue, Green, Grey, Yellow, Yellow, Red, Green, Green, Grey ]

                        expectedList =
                            Array.fromList [ Grey, Grey, Grey, Red, Blue, Green, Yellow, Yellow, Red, Green, Green ]
                    in
                        Board.sortColorsInRow colorsList
                            |> equal expectedList
            ]
        , describe "Board.fallRightColors (BDD)"
            [ test "In a Board of colors, gathers all colors different from Grey towards row's tails" <|
                \() ->
                    Board.fallRightColors complexTestBoard
                        |> equal complexTestBoardOrdered
            ]
        ]


testBoard : Array (Array Color)
testBoard =
    Array.fromList
        [ Array.fromList [ Blue, Blue, Red ]
        , Array.fromList [ Blue, Red, Red ]
        ]


complexTestBoard : Array (Array Color)
complexTestBoard =
    Array.fromList
        [ Array.fromList [ Blue, Grey, Grey, Red, Red, Red ]
        , Array.fromList [ Blue, Blue, Grey, Grey, Red, Red ]
        , Array.fromList [ Grey, Blue, Grey, Blue, Grey, Blue ]
        , Array.fromList [ Grey, Blue, Grey, Grey, Grey, Blue ]
        , Array.fromList [ Blue, Blue, Blue, Blue, Blue, Blue ]
        , Array.fromList [ Grey, Blue, Blue, Grey, Grey, Blue ]
        , Array.fromList [ Blue, Grey, Grey, Blue, Blue, Blue ]
        ]


complexTestBoardOrdered : Array (Array Color)
complexTestBoardOrdered =
    Array.fromList
        [ Array.fromList [ Grey, Grey, Blue, Red, Red, Red ]
        , Array.fromList [ Grey, Grey, Blue, Blue, Red, Red ]
        , Array.fromList [ Grey, Grey, Grey, Blue, Blue, Blue ]
        , Array.fromList [ Grey, Grey, Grey, Grey, Blue, Blue ]
        , Array.fromList [ Blue, Blue, Blue, Blue, Blue, Blue ]
        , Array.fromList [ Grey, Grey, Grey, Blue, Blue, Blue ]
        , Array.fromList [ Grey, Grey, Blue, Blue, Blue, Blue ]
        ]
