module Main exposing (main)

import Array
import Browser
import Html exposing (Html, button, div, h1, li, main_, ol, p, span, text)
import Html.Events exposing (onClick)
import Random
import Time



-- CONSTANTS


winScore =
    7


timeLimit =
    40


rules =
    Array.fromList [ "rule1", "rule2" ]


words =
    Array.fromList [ "word1", "word2" ]



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { showInstructions : Bool
    , word : String
    , rule : String
    , timeRemaining : Int
    , score1 : Int
    , score2 : Int
    }



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model False "???" "???" 0 0 0, Cmd.none )



-- UPDATE


type Msg
    = GetNewWord
    | NewWord String
    | GetNewRule
    | NewRule String
    | ResetTimer
    | NewTime Time.Posix
    | IncrementScore1
    | DecrementScore1
    | IncrementScore2
    | DecrementScore2
    | ShowInstructions
    | HideInstructions


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNewWord ->
            ( model, Random.generate NewWord randomWord )

        NewWord newWord ->
            ( { model | word = newWord }, Cmd.none )

        GetNewRule ->
            ( model, Random.generate NewRule randomRule )

        NewRule newRule ->
            ( { model | rule = newRule }, Cmd.none )

        ResetTimer ->
            ( { model | timeRemaining = timeLimit }, Cmd.none )

        NewTime _ ->
            ( { model | timeRemaining = model.timeRemaining - 1 }, Cmd.none )

        IncrementScore1 ->
            ( { model | score1 = normalizeScore 0 winScore (model.score1 + 1) }, Cmd.none )

        DecrementScore1 ->
            ( { model | score1 = normalizeScore 0 winScore (model.score1 - 1) }, Cmd.none )

        IncrementScore2 ->
            ( { model | score2 = normalizeScore 0 winScore (model.score2 + 1) }, Cmd.none )

        DecrementScore2 ->
            ( { model | score2 = normalizeScore 0 winScore (model.score2 - 1) }, Cmd.none )

        ShowInstructions ->
            ( { model | showInstructions = True }, Cmd.none )

        HideInstructions ->
            ( { model | showInstructions = False }, Cmd.none )



-- UPDATE HELPERS: GENERATORS


randomWord : Random.Generator String
randomWord =
    Random.map
        (\index -> Maybe.withDefault "" (Array.get index words))
        (Random.int 0 (Array.length words - 1))


randomRule : Random.Generator String
randomRule =
    Random.map
        (\index -> Maybe.withDefault "" (Array.get index rules))
        (Random.int 0 (Array.length words - 1))



-- UPDATE HELPERS: SCORE


normalizeScore : Int -> Int -> Int -> Int
normalizeScore minScore maxScore score =
    if score < minScore then
        minScore

    else if score > maxScore then
        maxScore

    else
        score



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 NewTime



-- VIEW


view : Model -> Html Msg
view model =
    main_ []
        [ viewInstructions model
        , viewWord model
        , viewRule model
        , viewTime model
        , viewScore model
        ]



-- VIEW COMPONENTS


viewInstructions : Model -> Html Msg
viewInstructions model =
    if model.showInstructions then
        div []
            [ button [ onClick HideInstructions ] [ text "Hide" ]
            , ol []
                [ li [] [ text "With at least 4 players, make 2 teams and pick 1 rep from each team." ]
                , li [] [ text "Together, reps draw a single shared word. Teams will compete to guess this word." ]
                , li [] [ text <| "Now each side takes turns, " ++ String.fromInt timeLimit ++ " seconds per side:" ]
                , li [] [ text "The first team to guess the word gets 1 point." ]
                , li [] [ text "After the word is guessed, each team picks 1 new rep. " ]
                , li [] [ text <| "The first team to " ++ String.fromInt winScore ++ " 7 points wins." ]
                ]
            ]

    else
        div [] [ button [ onClick ShowInstructions ] [ text "How to play?" ] ]


viewWord : Model -> Html Msg
viewWord model =
    div []
        [ h1 [] [ text "Word" ]
        , p [] [ text <| String.toUpper model.word ]
        , button [ onClick GetNewWord ] [ text "New word" ]
        ]


viewRule : Model -> Html Msg
viewRule model =
    div []
        [ h1 [] [ text "Rule" ]
        , p [] [ text model.rule ]
        , button [ onClick GetNewRule ] [ text "New rule" ]
        ]


viewTime : Model -> Html Msg
viewTime model =
    div []
        [ h1 [] [ text "Timer" ]
        , if model.timeRemaining > 0 then
            p [] [ text <| String.fromInt model.timeRemaining ++ "s" ]

          else
            p [] [ text "Time's up!" ]
        , button [ onClick ResetTimer ] [ text "Reset" ]
        ]


viewScore : Model -> Html Msg
viewScore model =
    div []
        [ if model.score1 >= winScore then
            h1 [] [ text "Team 1 wins!" ]

          else if model.score2 >= winScore then
            h1 [] [ text "Team 2 wins!" ]

          else
            h1 [] [ text "Score" ]
        , p []
            [ text "Team 1: "
            , button [ onClick DecrementScore1 ] [ text "-" ]
            , span [] [ text <| " " ++ String.fromInt model.score1 ++ " " ]
            , button [ onClick IncrementScore1 ] [ text "+" ]
            ]
        , p []
            [ text "Team 2: "
            , button [ onClick DecrementScore2 ] [ text "-" ]
            , span [] [ text <| " " ++ String.fromInt model.score2 ++ " " ]
            , button [ onClick IncrementScore2 ] [ text "+" ]
            ]
        ]
