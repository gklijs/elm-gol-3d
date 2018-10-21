port module Main exposing (..)

import Browser
import Html.Events exposing (onClick)
import Debug exposing (toString)
import Html exposing (Html, br, button, div, h1, img, text)
import Html.Attributes exposing (src)


---- MODEL ----


type alias Model =
    { counter: Int}

init : ( Model, Cmd Msg)
init =
    ({counter = 0}, Cmd.none)



---- UPDATE ----



type Msg
    = NoOp
    | Inc
    | Dec


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        Inc ->
            ( { model | counter = model.counter + 1}
            , logger ("Elm-count up " ++ (toString (model.counter + 1))))
        Dec ->
            ( { model | counter = model.counter - 1}
            , tick ("Elm-count down " ++ (toString (model.counter - 1))))
        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/images/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        ,button [ onClick Inc ] [ text "+" ]
                , br [] []
                , text (toString model)
                , br [] []
                , button [ onClick Dec ] [ text "-" ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.document
        { view =
            \m ->
                { title = "Elm 0.19 starter"
                , body = [ view m ]
                }
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }

port logger : String -> Cmd msg
port tick : String -> Cmd msg