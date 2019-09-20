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
import Models as M exposing (..)



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


view : Model -> Html Msg
view model =
    case model of
        DisplayBook book ->
            div []
                [ h1 []
                    [ text book.title ]
                , div []
                    [ displayPart
                        book.parts
                    ]
                ]


needsMastery : Maybe Mastery -> Bool
needsMastery mastery =
    case mastery of
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


displayPart : List Part -> Html Msg
displayPart parts =
    let
        createPartElems =
            \part ->
                li
                    [ classList
                        [ ( "has-read", hasRead part.mastery ) ]
                    ]
                    [ text part.name, displayChapters part.chapters ]

        contents =
            List.map createPartElems parts
    in
    ul [ class "book-parts" ] contents


displayChapters : List Chapter -> Html Msg
displayChapters chapters =
    let
        createListElems =
            \chapter -> li [] [ text chapter.name ]

        contents =
            List.map createListElems chapters
    in
    ul [ class "book-chapters" ] contents
