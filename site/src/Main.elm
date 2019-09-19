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
    = Failure
    | Loading
    | Success String
    | DisplayBook BookSection


type BookSection
    = BookSection
        { -- the type ChildSection is a helper to allow recursive typing here
          children : List BookSection
        , mastery : Maybe Mastery
        , name : String
        }


type ChildSection
    = ChildSection ()


type alias Mastery =
    { read : Bool
    , examples : Bool
    , moreResearch : Bool
    , morePractice : Bool
    }


initialBook : BookSection
initialBook =
    BookSection
        { name = "Cracking the Coding Interview"
        , mastery = Nothing
        , children =
            [ BookSection
                { name = "Big O"
                , mastery = Nothing
                , children =
                    [ BookSection { name = "Big-O Notation", mastery = Nothing, children = [] }
                    ]
                }
            ]
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( DisplayBook initialBook
    , Cmd.none
    )



--     ( Loading
--     , Http.get
--         { url = "https://elm-lang.org/assets/public-opinion.txt"
--         , expect = Http.expectString GotText
--         }
--     )
-- UPDATE


type Msg
    = GotText (Result Http.Error String)
    | SelectedBook BookSection


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )

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
        Failure ->
            text "I was unable to load your book."

        Loading ->
            text "Loading..."

        Success fullText ->
            pre [] [ text fullText ]

        DisplayBook book ->
            h1 [] [ text "WE DID IT BOYS!" ]
