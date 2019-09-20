-- Make a GET request to load a book called "Public Opinion"
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/http.html
--


module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Http



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
    , chapters : List BookSection
    }


type BookSection
    = BookSection
        { name : String
        , children : ChildSection
        , mastery : Maybe Mastery
        }


type ChildSection
    = ChildSection (List BookSection)


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
        [ BookSection
            { name = "Big O"
            , mastery = Nothing
            , children =
                ChildSection
                    [ BookSection { name = "Big-O Notation", mastery = Nothing, children = ChildSection [] }
                    ]
            }
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
            h1 []
                [ text book.title
                    ul
                    []
                    [ map (\chapter -> li [] [ text chapter.name ]) book.chapters
                    ]
                ]
