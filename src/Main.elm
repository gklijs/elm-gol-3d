port module Main exposing (..)

import Browser
import Html.Events exposing (onClick)
import Debug exposing (log, toString)
import Html exposing (Html, br, button, div, h1, img, li, text, ul)
import Html.Attributes exposing (id, src)
import Json.Decode as JD exposing (Decoder, Value, oneOf, field, map, int, at, succeed, map2)
import Json.Encode as JE exposing (encode, object, int)

---- MODEL ----


type alias Model =
    { counter : Int
    , outs : List FromGol}

init : ( Model, Cmd Msg)
init =
    ({counter = 0, outs = []}, Cmd.none)


---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions _ =
    fromGol mapGol

---- UPDATE ----


type Msg
    = NoOp
    | Inc
    | Dec
    | Xs FromGol

type alias Tick = { tick : Int, bla: String}
type alias Height = { height : Int}
type alias Width = { width : Int}
type alias Depth = { depth : Int}

type FromGol
    = None
    | TickMsg Tick
    | HeightMsg Height
    | WidthMsg Width
    | DepthMsg Depth


golToText : FromGol -> String
golToText gol2 =
    case gol2 of
        None -> "No value"
        TickMsg i -> "tick " ++ String.fromInt i.tick
        HeightMsg i -> "height " ++ String.fromInt i.height
        WidthMsg i -> "width " ++ String.fromInt i.width
        DepthMsg i -> "depth " ++ String.fromInt i.depth


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        Inc ->
            ( { model | counter = model.counter + 1}
            , toGol (JE.encode 0 (JE.object [("width", JE.int (model.counter + 1))])))
        Dec ->
            ( { model | counter = model.counter - 1}
            , toGol (JE.encode 0 (JE.object [("width", JE.int (model.counter - 1))])))
        NoOp ->
            ( model, Cmd.none )
        Xs out ->
            ( {model | outs = out :: model.outs}, Cmd.none)

---- DECODING ----

mapGol : JD.Value -> Msg
mapGol jsonGol =
    case decodeGol jsonGol of
        Ok result ->
            Xs result
        Err _ ->
            Xs None

decodeGol : JD.Value -> Result JD.Error FromGol
decodeGol modelGol =
    JD.decodeValue gol modelGol

tickDecoder : JD.Decoder Tick
tickDecoder =
    JD.map2 Tick
    (JD.field "tick" JD.int)
    (JD.field "bla" JD.string)

heightDecoder : JD.Decoder Height
heightDecoder =
    JD.map Height (JD.field "height" JD.int)

widthDecoder : JD.Decoder Width
widthDecoder =
    JD.map Width (JD.field "width" JD.int)

depthDecoder : JD.Decoder Depth
depthDecoder =
    JD.map Depth (JD.field "depth" JD.int)


gol : JD.Decoder FromGol
gol =
    JD.oneOf
        [
        JD.map TickMsg tickDecoder
        , JD.map HeightMsg heightDecoder
        , JD.map WidthMsg widthDecoder
        , JD.map DepthMsg depthDecoder
        ]

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

commentItem : FromGol -> Html Msg
commentItem comment =
    li [] [ text (golToText comment) ]


commentList : List FromGol -> Html Msg
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
port fromGol : (JD.Value -> msg) -> Sub msg