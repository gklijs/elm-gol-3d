port module Main exposing (..)

import Browser
import Html.Events exposing (onClick)
import Debug exposing (toString)
import Html exposing (Html, br, button, div, h1, img, li, text, ul)
import Html.Attributes exposing (id, src)


---- MODEL ----


type alias Model =
    { counter : Int
    , outs : List String}

init : ( Model, Cmd Msg)
init =
    ({counter = 0, outs = []}, Cmd.none)


---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions _ =
    fromGol NewOut

---- UPDATE ----



type Msg
    = NoOp
    | Inc
    | Dec
    | NewOut String


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        Inc ->
            ( { model | counter = model.counter + 1}
            , toGol ("Elm-count up " ++ (toString (model.counter + 1))))
        Dec ->
            ( { model | counter = model.counter - 1}
            , toGol ("Elm-count down " ++ (toString (model.counter - 1))))
        NoOp ->
            ( model, Cmd.none )
        NewOut out ->
            ( {model | outs = out :: model.outs}, Cmd.none)


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
        , commentList model.outs
        ]

commentItem : String -> Html Msg
commentItem comment =
    li [] [ text comment ]


commentList : List String -> Html Msg
commentList comments =
    ul [ id "comments" ] (List.map commentItem comments)



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
        , subscriptions = subscriptions
        }

port toGol : String -> Cmd msg
port fromGol : (String -> msg) -> Sub msg