port module Main exposing (..)

import Browser
import Html.Events as E exposing (on, onClick, onInput, targetValue)
import Debug exposing (log, toString)
import Html exposing (Html, br, button, div, h1, img, input, li, text, ul)
import Html.Attributes exposing (id, max, min, src, type_, value)
import Json.Decode as JD exposing (Decoder, Value, oneOf, field, map, int, at, succeed, map3, list)
import Json.Encode as JE exposing (encode, object, int)

---- MODEL ----


type alias Model =
    { width : Int
    , heigth : Int
    , depth : Int
    , outs : List FromGol}

init : ( Model, Cmd Msg)
init =
    ({width = 10, heigth = 10, depth = 10, outs = []}, Cmd.none)


---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions _ =
    fromGol mapGol

---- UPDATE ----


type Msg
    = NoOp
    | UpdateHeight String
    | UpdateWidth String
    | UpdateDepth String
    | Xs FromGol

type alias InitialState = { cells: List Bool}
type alias UpdateState = { births : List Int, deaths : List Int, ticks: Int}

type FromGol
    = None
    | InitialStateMsg InitialState
    | UpdateStateMsg UpdateState


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        Xs out ->
            ( {model | outs = out :: model.outs}, Cmd.none)
        UpdateHeight newHeight ->
            ( {model | heigth = String.toInt newHeight |> Maybe.withDefault 10}
            , toGol (JE.encode 0 (JE.object [("height", JE.int model.heigth)])))
        UpdateWidth newWidth ->
            ( {model | width = String.toInt newWidth |> Maybe.withDefault 10}
            , toGol (JE.encode 0 (JE.object [("width", JE.int model.width)])))
        UpdateDepth newDepth ->
            ( {model | depth = String.toInt newDepth |> Maybe.withDefault 10}
            , toGol (JE.encode 0 (JE.object [("depth", JE.int model.depth)])))

---- DECODING ----

mapGol : JD.Value -> Msg
mapGol jsonGol =
    case (log "result" (decodeGol jsonGol)) of
        Ok result ->
            Xs result
        Err _ ->
            Xs None

decodeGol : JD.Value -> Result JD.Error FromGol
decodeGol modelGol =
    JD.decodeValue gol modelGol

initialStateDecoder : JD.Decoder InitialState
initialStateDecoder =
    JD.map InitialState
    (JD.field "cells" (JD.list JD.bool))

updateStateDecoder : JD.Decoder UpdateState
updateStateDecoder =
    JD.map3 UpdateState
    (JD.field "births" (JD.list JD.int))
    (JD.field "deaths" (JD.list JD.int))
    (JD.field "ticks" JD.int)

gol : JD.Decoder FromGol
gol =
    JD.oneOf
        [
        JD.map InitialStateMsg initialStateDecoder
        , JD.map UpdateStateMsg updateStateDecoder
        ]

---- VIEW ----

view : Model -> Html Msg
view model =
    div []
        [ img [ src "/images/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , input [ type_ "range"
        , min "5"
        , max "50"
        , value <| toString model.heigth
        , onInput UpdateHeight
        ] []
        , input [ type_ "range"
        , min "5"
        , max "50"
        , value <| toString model.width
        , onInput UpdateWidth
        ] []
        , input [ type_ "range"
        , min "5"
        , max "50"
        , value <| toString model.depth
        , onInput UpdateDepth
        ] []
        , div [] [text (toString model)]
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
        , subscriptions = subscriptions
        }

port toGol : String -> Cmd msg
port fromGol : (JD.Value -> msg) -> Sub msg