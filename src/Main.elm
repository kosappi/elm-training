module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Http


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { resultCore : String
    , resultSvg : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { resultCore = "", resultSvg = "" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Click
    | GotCoreModule (Result Http.Error String)
    | GotSvgModule (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click ->
            ( model
            , Cmd.batch
                [ Http.get
                    { url = "https://api.github.com/repos/elm/core"
                    , expect = Http.expectString GotCoreModule
                    }
                , Http.get
                    { url = "https://api.github.com/repos/elm/svg"
                    , expect = Http.expectString GotSvgModule
                    }
                ]
            )

        GotCoreModule (Ok repo) ->
            ( { model | resultCore = repo }, Cmd.none )

        GotCoreModule (Err error) ->
            ( { model | resultCore = Debug.toString error }, Cmd.none )

        GotSvgModule (Ok repo) ->
            ( { model | resultSvg = repo }, Cmd.none )

        GotSvgModule (Err error) ->
            ( { model | resultSvg = Debug.toString error }, Cmd.none )

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Click ] [ text "Get Repository Info" ]
        , p [] [ text model.resultCore ]
        , p [] [ text model.resultSvg ]
        ]