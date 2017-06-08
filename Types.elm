module Types exposing (..)

import Colors exposing (Color)


type alias Model =
    { board : List (List Color)
    }


type Msg
    = Touch ( Int, Int )
