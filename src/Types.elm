module Types exposing (..)

import Array exposing (Array)


type Color
    = Blue
    | Green
    | Yellow
    | Red
    | Grey


type alias Board =
    Array (Array Color)


type alias Model =
    { board : Board
    , finished : Bool
    , seed : Maybe (Array (Array Int))
    }


type alias Coord =
    ( Int, Int )


type Direction
    = Top
    | Right
    | Bottom
    | Left


type Msg
    = Touch Coord
    | Reset
    | Fall
    | UpdateSeed (Array (Array Int))
