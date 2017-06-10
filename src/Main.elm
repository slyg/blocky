module Main exposing (..)

import Html exposing (Html, div, button, text, program)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Array exposing (fromList)
import Types exposing (..)
import Board


init =
    ( { board =
            fromList
                [ fromList [ Blue, Blue, Green, Green, Yellow, Yellow ]
                , fromList [ Blue, Blue, Yellow, Yellow, Yellow, Yellow ]
                , fromList [ Green, Yellow, Yellow, Red, Green, Yellow ]
                , fromList [ Red, Red, Red, Red, Green, Yellow ]
                , fromList [ Blue, Yellow, Red, Red, Green, Yellow ]
                , fromList [ Blue, Blue, Green, Red, Red, Yellow ]
                ]
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            init

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
    div []
        [ (Board.view data.board)
        , div [ style [ ( "text-align", "center" ) ] ]
            [ button [ onClick Reset ] [ text "Reset" ]
            ]
        ]


main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
