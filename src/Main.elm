module Main exposing (..)

import Html exposing (Html, div, button, text)
import Browser
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Array exposing (fromList, Array)
import Task
import Process
import Types exposing (..)
import Board
import Random exposing (Generator)
import Debug exposing (toString)
import Array exposing (toList)
import Random.Array


colorList : Array Color
colorList =
    fromList [ Red, Green, Blue, Yellow, Grey ]

indexesToColor : (Array (Array Int)) -> Board
indexesToColor indexes =
    indexes
        |> Array.map (\j -> 
            j 
            |> Array.map (\i -> 
                 Maybe.withDefault Red (Array.get i colorList)
            ) 
        )

randMatrixGenerator : Generator (Array (Array Int))
randMatrixGenerator =
    let
        rowLen = Array.length colorList + 1
        gen = Random.int 0 (rowLen - 1)
    in
        Random.Array.array rowLen (Random.Array.array rowLen gen)

defaultBoard : Board
defaultBoard =
    fromList
        [ fromList [ Blue, Blue, Green, Green, Yellow, Yellow ]
        , fromList [ Blue, Blue, Yellow, Yellow, Yellow, Yellow ]
        , fromList [ Green, Yellow, Yellow, Red, Green, Yellow ]
        , fromList [ Red, Red, Red, Red, Green, Yellow ]
        , fromList [ Blue, Yellow, Red, Red, Green, Yellow ]
        , fromList [ Blue, Blue, Green, Red, Red, Yellow ]
        ]

init : () -> (Model, Cmd Msg)
init _ =
    ( { board = defaultBoard
      , finished = False
      , seed = Nothing
      }
    , Random.generate UpdateSeed randMatrixGenerator
    )


delay : Float -> Msg -> Cmd Msg
delay time msg =
    time
        |> Process.sleep
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of

        UpdateSeed seed ->
            ( { model | seed = Just seed }, Cmd.none )

        Reset ->
            init ()

        Touch coord ->
            let
                kins =
                    (Board.searchKins model.board coord)

                newBoard =
                    kins
                        |> List.foldr (\c board -> Board.update board Grey c) model.board
            in
                ( { model
                    | board = newBoard
                  }
                , delay (1 * 0.2) Fall
                )

        Fall ->
            let
                rowIsCompleted row =
                    row
                        |> Array.foldl (\color acc -> acc && color == Grey) True

                boardIsCompleted =
                    Debug.log "truc"
                        (model.board
                            |> Array.map rowIsCompleted
                            |> Array.foldl (\completed acc -> acc && completed) True
                        )
            in
                ( { model
                    | board = Board.fallRightColors model.board
                    , finished = boardIsCompleted
                  }
                , Cmd.none
                )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    let
        restartButton =
            if model.finished
            then
                div
                    [ style  "text-align" "center" ]
                    [ button [ onClick Reset ] [ text "Restart" ] ]
            else
                div [] []
        seedValue : String
        seedValue =
            case model.seed of
                Nothing ->
                    "No seed"
                Just seed ->
                    let
                        colorsString =
                            indexesToColor seed
                                |> Array.map (\color -> color |> toString)
                                |> toList
                                |> toString
                    in
                        colorsString
    in
        div []
            [ div []
                [ Board.view model.board
                , restartButton
                ]
            , div []
                [ text "Seed: "
                , text seedValue
                ]
            ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }