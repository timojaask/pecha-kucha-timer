module Main exposing (..)

import Browser
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


secondsPerSlide : Int
secondsPerSlide =
    3


numberOfSlides : Int
numberOfSlides =
    3


slideEndWarningLengthSeconds : Int
slideEndWarningLengthSeconds =
    1


type alias Model =
    { slide : Int
    , secondsSinceSlideStart : Int
    , state : State
    }


type State
    = Running
    | SlideEndWarning
    | PresentationEnded


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 0 Running
    , Cmd.none
    )



-- UPDATE


type Msg
    = Reset
    | Tick Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( { model | slide = 0, secondsSinceSlideStart = 0 }, Cmd.none )

        Tick _ ->
            ( { model
                | secondsSinceSlideStart = nextSecondsSinceSlideStart model
                , slide = updateSlide model
              }
            , Cmd.none
            )


nextSecondsSinceSlideStart : Model -> Int
nextSecondsSinceSlideStart model =
    case model.state of
        Running ->
            if model.secondsSinceSlideStart >= secondsPerSlide then
                0

            else
                model.secondsSinceSlideStart + 1

        SlideEndWarning ->
            if model.secondsSinceSlideStart >= secondsPerSlide then
                0

            else
                model.secondsSinceSlideStart + 1

        PresentationEnded ->
            model.secondsSinceSlideStart


updateSlide : Model -> Int
updateSlide model =
    if model.secondsSinceSlideStart >= secondsPerSlide then
        model.slide + 1

    else
        model.slide



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Reset ] [ text "Reset" ]
        , div [] [ text (String.fromInt model.slide) ]
        , div [] [ text (String.fromInt model.secondsSinceSlideStart) ]
        ]
