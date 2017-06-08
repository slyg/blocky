module Main exposing (..)

import Html exposing (Html, div, program)
import List
import Types exposing (..)
import Colors exposing (Color(..))
import Board exposing (board)


init =
    ( { board =
            [ [ Blue, Blue, Green, Green, Green ]
            , [ Green, Yellow, Yellow, Red, Green ]
            , [ Red, Red, Red, Red, Yellow ]
            , [ Blue, Yellow, Red, Red, Blue ]
            , [ Blue, Blue, Green, Green, Red ]
            ]
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Msg" msg of
        Touch ( x, y ) ->
            ( model
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view data =
    div [] [ (board data.board) ]


main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
