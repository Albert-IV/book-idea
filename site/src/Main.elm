-- Make a GET request to load a book called "Public Opinion"
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/http.html
--


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
                    Debug.log "Loaded book" ( DisplayBook book, Cmd.none )

                ToggleMastery clickEvent ->
                    case clickEvent.msgType of
                        PartRecord ->
                            Debug.log "this should be updating the book..." ( togglePartMastery clickEvent currentBook, Cmd.none )

                        ChapterRecord ->
                            Debug.log "Chapter updated?" ( DisplayBook (toggleChapterMastery clickEvent currentBook), Cmd.none )

        _ ->
            Debug.log "Nothing... happened?" ( model, Cmd.none )


getPart : Int -> Book -> Maybe Part
getPart partIdx book =
    get partIdx book.parts


getChapter : Int -> Int -> Book -> Maybe Chapter
getChapter chapterIdx partIdx book =
    case getPart partIdx book of
        Nothing ->
            Nothing

        Just part ->
            get chapterIdx part.chapters


toggleRead : Mastery -> Mastery
toggleRead mastery =
    { mastery | read = not mastery.read }


toggleExample : Mastery -> Mastery
toggleExample mastery =
    { mastery | examples = not mastery.examples }


toggleResearch : Mastery -> Mastery
toggleResearch mastery =
    { mastery | moreResearch = not mastery.moreResearch }


togglePractice : Mastery -> Mastery
togglePractice mastery =
    { mastery | morePractice = not mastery.morePractice }


togglePartMastery : ClickMsg -> Book -> Model
togglePartMastery msg book =
    let
        maybePart =
            getPart msg.partIdx book

        updatedMastery =
            case maybePart of
                Nothing ->
                    Debug.log "Found nothing for maybePart" Nothing

                Just part ->
                    case part.mastery of
                        Nothing ->
                            Debug.log "Found nothing for maybePart.mastery" Nothing

                        Just mastery ->
                            Debug.log "Toggling mastery" Just (toggleRead mastery)

        updatedPart =
            case maybePart of
                Nothing ->
                    Debug.log "Found nothing for maybePart" Nothing

                Just part ->
                    case updatedMastery of
                        Nothing ->
                            Debug.log "Found nothing for maybePart.mastery" Nothing

                        Just mastery ->
                            Debug.log "Setting new mastery for part" Just { part | mastery = Just mastery }

        updatedBook =
            case updatedPart of
                Nothing ->
                    Debug.log "Found nothing for updatedPart" Nothing

                Just newPart ->
                    Debug.log "Setting new part on book object" Just { book | parts = set msg.partIdx newPart book.parts }
    in
    case updatedBook of
        Nothing ->
            Debug.log "error updating book" ErrorUpdatingBook book "Unable to update book!"

        Just newBook ->
            Debug.log "this should be getting the new book :thinking_face:" DisplayBook newBook


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
chapterContent partIdx chapterTuple =
    let
        chapterIdx =
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
                    [ masteryReadBtn mastery (ClickMsg partIdx chapterIdx "read" msgType)
                    , masteryExamplesBtn mastery (ClickMsg partIdx chapterIdx "examples" msgType)
                    , masteryResearchBtn mastery (ClickMsg partIdx chapterIdx "moreResearch" msgType)
                    , masteryPracticeBtn mastery (ClickMsg partIdx chapterIdx "morePractice" msgType)
                    ]
                :: []


masteryReadBtn : Mastery -> ClickMsg -> Html Msg
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


masteryReadText : Mastery -> String
masteryReadText mastery =
    if mastery.read then
        "Chapter Read"

    else
        "Chapter Unread"


masteryExamplesBtn : Mastery -> ClickMsg -> Html Msg
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


masteryExamplesText : Mastery -> String
masteryExamplesText mastery =
    if mastery.examples then
        "Examples Complete"

    else
        "Examples Incomplete"


masteryResearchBtn : Mastery -> ClickMsg -> Html Msg
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


masteryResearchText : Mastery -> String
masteryResearchText mastery =
    if mastery.moreResearch then
        "Needs More Research"

    else
        "No Research Necessary"


masteryPracticeBtn : Mastery -> ClickMsg -> Html Msg
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


masteryPracticeText : Mastery -> String
masteryPracticeText mastery =
    if mastery.morePractice then
        "Needs More Practice"

    else
        "No Practice Necessary"
