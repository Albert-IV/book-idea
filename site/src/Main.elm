module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Array exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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
    | ErrorUpdatingBook Book String


init : () -> ( Model, Cmd Msg )
init _ =
    ( DisplayBook initialBook
    , Cmd.none
    )


type Msg
    = SelectedBook Book
    | ToggleMastery ClickMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        DisplayBook currentBook ->
            case msg of
                SelectedBook book ->
                    ( DisplayBook book, Cmd.none )

                ToggleMastery clickEvent ->
                    case clickEvent.msgType of
                        PartRecord ->
                            ( updatePartMastery clickEvent currentBook, Cmd.none )

                        ChapterRecord ->
                            ( updateChapterMastery clickEvent currentBook, Cmd.none )

        _ ->
            ( model, Cmd.none )


getPart : Int -> Book -> Maybe Part
getPart partIdx book =
    get partIdx book.parts


getChapter : Int -> Int -> Book -> Maybe Chapter
getChapter chapterIdx partIdx book =
    case getPart partIdx book of
        Nothing ->
            Nothing

        Just part ->
            Array.get chapterIdx part.chapters


toggleRead : Completion -> Completion
toggleRead mastery =
    { mastery | read = not mastery.read }


toggleExample : Completion -> Completion
toggleExample mastery =
    { mastery | examples = not mastery.examples }


toggleResearch : Completion -> Completion
toggleResearch mastery =
    { mastery | moreResearch = not mastery.moreResearch }


togglePractice : Completion -> Completion
togglePractice mastery =
    { mastery | morePractice = not mastery.morePractice }


updatePartMastery : ClickMsg -> Book -> Model
updatePartMastery msg book =
    let
        maybePart =
            getPart msg.partIdx book

        updatedMastery =
            case maybePart of
                Nothing ->
                    Nothing

                Just part ->
                    case part.mastery of
                        Nothing ->
                            Nothing

                        Just mastery ->
                            case msg.mastery of
                                "read" ->
                                    Just (toggleRead mastery)

                                "examples" ->
                                    Just (toggleExample mastery)

                                "moreResearch" ->
                                    Just (toggleResearch mastery)

                                "morePractice" ->
                                    Just (togglePractice mastery)

                                _ ->
                                    Nothing

        updatedPart =
            case maybePart of
                Nothing ->
                    Nothing

                Just part ->
                    case updatedMastery of
                        Nothing ->
                            Nothing

                        Just mastery ->
                            Just { part | mastery = Just mastery }

        updatedBook =
            case updatedPart of
                Nothing ->
                    Nothing

                Just newPart ->
                    Just { book | parts = set msg.partIdx newPart book.parts }
    in
    case updatedBook of
        Nothing ->
            ErrorUpdatingBook book "Unable to update book!"

        Just newBook ->
            DisplayBook newBook


updateChapterMastery : ClickMsg -> Book -> Model
updateChapterMastery msg book =
    let
        maybePart =
            getPart msg.partIdx book

        maybeChapter =
            getChapter msg.chapterIdx msg.partIdx book

        updatedMastery =
            case maybeChapter of
                Nothing ->
                    Nothing

                Just chapter ->
                    case chapter.mastery of
                        Nothing ->
                            Nothing

                        Just mastery ->
                            case msg.mastery of
                                "read" ->
                                    Just (toggleRead mastery)

                                "examples" ->
                                    Just (toggleExample mastery)

                                "moreResearch" ->
                                    Just (toggleResearch mastery)

                                "morePractice" ->
                                    Just (togglePractice mastery)

                                _ ->
                                    Nothing

        updatedChapter =
            case maybeChapter of
                Nothing ->
                    Nothing

                Just chapter ->
                    case updatedMastery of
                        Nothing ->
                            Nothing

                        Just newMastery ->
                            Just { chapter | mastery = Just newMastery }

        updatedPart =
            case maybePart of
                Nothing ->
                    Nothing

                Just part ->
                    case updatedChapter of
                        Nothing ->
                            Nothing

                        Just newChapter ->
                            Just { part | chapters = set msg.chapterIdx newChapter part.chapters }

        updatedBook =
            case updatedPart of
                Nothing ->
                    Nothing

                Just newPart ->
                    Just { book | parts = set msg.partIdx newPart book.parts }
    in
    case updatedBook of
        Nothing ->
            ErrorUpdatingBook book "Unable to update book!"

        Just newBook ->
            DisplayBook newBook


toggleChapterMastery : ClickMsg -> Book -> Book
toggleChapterMastery msg book =
    book



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
                    [ div [] (toList (indexedMap partContent book.parts))
                    ]
                ]

        ErrorUpdatingBook book msg ->
            div [ class "container" ]
                [ h1 [] [ text msg ]
                , h1 []
                    [ text book.title ]
                , div []
                    [ div [] (toList (indexedMap partContent book.parts))
                    ]
                ]


partContent : Int -> Part -> Html Msg
partContent partIdx part =
    let
        chapterTuples =
            Array.map (\chapter -> ( partIdx, chapter )) part.chapters
    in
    div [ class "card mb-3" ]
        [ div
            [ class "card-header d-flex justify-content-between align-items-center" ]
            (buttonContent part partIdx 0 PartRecord)
        , ul [ class "list-group list-group-flush" ] (toList (indexedMap chapterContent chapterTuples))
        ]


chapterContent : Int -> ( Int, Chapter ) -> Html Msg
chapterContent chapterIdx chapterTuple =
    let
        partIdx =
            Tuple.first chapterTuple

        chapter =
            Tuple.second chapterTuple

        contents =
            case chapter.mastery of
                Nothing ->
                    li [ class "list-group-item" ] [ text chapter.name ]

                Just mastery ->
                    li
                        [ class "list-group-item d-flex justify-content-between align-items-center" ]
                        (buttonContent chapter partIdx chapterIdx ChapterRecord)
    in
    contents


buttonContent : BookButtons a -> Int -> Int -> RecordType -> List (Html Msg)
buttonContent chapterOrPart partIdx chapterIdx msgType =
    case chapterOrPart.mastery of
        Nothing ->
            [ text chapterOrPart.name ]

        Just mastery ->
            text chapterOrPart.name
                :: div []
                    [ masteryReadBtn mastery { partIdx = partIdx, chapterIdx = chapterIdx, mastery = "read", msgType = msgType }
                    , masteryExamplesBtn mastery { partIdx = partIdx, chapterIdx = chapterIdx, mastery = "examples", msgType = msgType }
                    , masteryResearchBtn mastery { partIdx = partIdx, chapterIdx = chapterIdx, mastery = "moreResearch", msgType = msgType }
                    , masteryPracticeBtn mastery { partIdx = partIdx, chapterIdx = chapterIdx, mastery = "morePractice", msgType = msgType }
                    ]
                :: []


masteryReadBtn : Completion -> ClickMsg -> Html Msg
masteryReadBtn mastery clickMsg =
    button
        [ classList
            [ ( "card-link btn", True )
            , ( "btn-primary", mastery.read )
            , ( "btn-danger", not mastery.read )
            ]
        , onClick (ToggleMastery clickMsg)
        ]
        [ text (masteryReadText mastery) ]


masteryReadText : Completion -> String
masteryReadText mastery =
    if mastery.read then
        "Chapter Read"

    else
        "Chapter Unread"


masteryExamplesBtn : Completion -> ClickMsg -> Html Msg
masteryExamplesBtn mastery clickMsg =
    button
        [ classList
            [ ( "card-link btn", True )
            , ( "btn-primary", mastery.examples )
            , ( "btn-danger", not mastery.examples )
            ]
        , onClick (ToggleMastery clickMsg)
        ]
        [ text (masteryExamplesText mastery) ]


masteryExamplesText : Completion -> String
masteryExamplesText mastery =
    if mastery.examples then
        "Examples Complete"

    else
        "Examples Incomplete"


masteryResearchBtn : Completion -> ClickMsg -> Html Msg
masteryResearchBtn mastery clickMsg =
    button
        [ classList
            [ ( "card-link btn", True )
            , ( "btn-primary", mastery.moreResearch )
            , ( "btn-danger", not mastery.moreResearch )
            ]
        , onClick (ToggleMastery clickMsg)
        ]
        [ text (masteryResearchText mastery) ]


masteryResearchText : Completion -> String
masteryResearchText mastery =
    if mastery.moreResearch then
        "Needs More Research"

    else
        "No Research Necessary"


masteryPracticeBtn : Completion -> ClickMsg -> Html Msg
masteryPracticeBtn mastery clickMsg =
    button
        [ classList
            [ ( "card-link btn", True )
            , ( "btn-primary", mastery.morePractice )
            , ( "btn-danger", not mastery.morePractice )
            ]
        , onClick (ToggleMastery clickMsg)
        ]
        [ text (masteryPracticeText mastery) ]


masteryPracticeText : Completion -> String
masteryPracticeText mastery =
    if mastery.morePractice then
        "Needs More Practice"

    else
        "No Practice Necessary"
