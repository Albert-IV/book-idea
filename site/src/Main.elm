-- Make a GET request to load a book called "Public Opinion"
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/http.html
--


module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import List
import Models exposing (..)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = DisplayBook Book


init : () -> ( Model, Cmd Msg )
init _ =
    ( DisplayBook initialBook
    , Cmd.none
    )


type Msg
    = SelectedBook Book


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectedBook book ->
            ( DisplayBook book, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


isJust : Maybe t -> Bool
isJust val =
    case val of
        Nothing ->
            False

        Just _ ->
            True


hasRead : Maybe Mastery -> Bool
hasRead mastery =
    case mastery of
        Nothing ->
            False

        Just { read } ->
            read


view : Model -> Html Msg
view model =
    case model of
        DisplayBook book ->
            div [ class "container" ]
                [ h1 []
                    [ text book.title ]
                , div []
                    [ div [] (List.map partContent book.parts)
                    ]
                ]


partContent : Part -> Html Msg
partContent part =
    div [ class "card mb-3" ]
        [ div [ class "card-header d-flex justify-content-between align-items-center" ] (buttonContent part)
        , ul [ class "list-group list-group-flush" ] (List.map chapterContent part.chapters)
        ]


chapterContent : Chapter -> Html Msg
chapterContent chapter =
    case chapter.mastery of
        Nothing ->
            li [ class "list-group-item" ] [ text chapter.name ]

        Just mastery ->
            li [ class "list-group-item d-flex justify-content-between align-items-center" ] (buttonContent chapter)


buttonContent : BookButtons a -> List (Html Msg)
buttonContent chapterOrPart =
    case chapterOrPart.mastery of
        Nothing ->
            [ text chapterOrPart.name ]

        Just mastery ->
            text chapterOrPart.name
                :: div []
                    [ masteryReadBtn mastery
                    , masteryExamplesBtn mastery
                    , masteryResearchBtn mastery
                    , masteryPracticeBtn mastery
                    ]
                :: []


masteryReadBtn : Mastery -> Html Msg
masteryReadBtn mastery =
    button
        [ classList
            [ ( "card-link btn", True )
            , ( "btn-primary", mastery.read )
            , ( "btn-danger", not mastery.read )
            ]
        ]
        [ text (masteryReadText mastery) ]


masteryReadText : Mastery -> String
masteryReadText mastery =
    if mastery.read then
        "Chapter Read"

    else
        "Chapter Unread"


masteryExamplesBtn : Mastery -> Html Msg
masteryExamplesBtn mastery =
    button
        [ classList
            [ ( "card-link btn", True )
            , ( "btn-primary", mastery.examples )
            , ( "btn-danger", not mastery.examples )
            ]
        ]
        [ text (masteryExamplesText mastery) ]


masteryExamplesText : Mastery -> String
masteryExamplesText mastery =
    if mastery.examples then
        "Examples Complete"

    else
        "Examples Incomplete"


masteryResearchBtn : Mastery -> Html Msg
masteryResearchBtn mastery =
    button
        [ classList
            [ ( "card-link btn", True )
            , ( "btn-primary", mastery.moreResearch )
            , ( "btn-danger", not mastery.moreResearch )
            ]
        ]
        [ text (masteryResearchText mastery) ]


masteryResearchText : Mastery -> String
masteryResearchText mastery =
    if mastery.moreResearch then
        "Needs More Research"

    else
        "No Research Necessary"


masteryPracticeBtn : Mastery -> Html Msg
masteryPracticeBtn mastery =
    button
        [ classList
            [ ( "card-link btn", True )
            , ( "btn-primary", mastery.morePractice )
            , ( "btn-danger", not mastery.morePractice )
            ]
        ]
        [ text (masteryPracticeText mastery) ]


masteryPracticeText : Mastery -> String
masteryPracticeText mastery =
    if mastery.morePractice then
        "Needs More Practice"

    else
        "No Practice Necessary"
