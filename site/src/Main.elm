-- Make a GET request to load a book called "Public Opinion"
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/http.html
--


module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Http
import List



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


type alias Book =
    { title : String
    , author : String
    , isbn : String
    , parts : List Part
    }


type alias Part =
    { name : String
    , mastery : Maybe Mastery
    , chapters : List Chapter
    }


type alias Chapter =
    { name : String
    , mastery : Maybe Mastery
    }


type alias Mastery =
    { read : Bool
    , examples : Bool
    , moreResearch : Bool
    , morePractice : Bool
    }


initialBook : Book
initialBook =
    Book
        "Cracking the Coding Interview"
        "AYY"
        "9010"
        [ Part "Big O"
            Nothing
            [ Chapter "Big-O Notation" Nothing
            ]
        ]


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


displayPart : List Part -> Html Msg
displayPart parts =
    let
        createPartElems =
            \part -> li [] [ text part.name, displayChapters part.chapters ]

        contents =
            List.map createPartElems parts
    in
    ul [] contents


displayChapters : List Chapter -> Html Msg
displayChapters chapters =
    let
        chapterNames =
            List.map .name chapters

        createListElems =
            \name -> li [] [ text name ]

        contents =
            List.map createListElems chapterNames
    in
    ul [] contents
