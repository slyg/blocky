module Main exposing (..)

import Html exposing (Html, div, program)
import Array exposing (fromList)
import Types exposing (..)
import Board


init =
    ( { board =
            fromList
                [ fromList [ Blue, Blue, Green, Green, Green ]
                , fromList [ Green, Yellow, Yellow, Red, Green ]
                , fromList [ Red, Red, Red, Red, Yellow ]
                , fromList [ Blue, Yellow, Red, Red, Blue ]
                , fromList [ Blue, Blue, Green, Red, Red ]
                ]
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Touch coord ->
            let
                kins =
                    (Board.searchKins model.board coord)

                newBoard =
                    kins
                        |> List.foldr (\coord board -> Board.update board Grey coord) model.board
                        |> Board.fallRightColors
            in
                ( { model | board = newBoard }
                , Cmd.none
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view data =
    div [] [ (Board.view data.board) ]


main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
