import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }

-- MODEL

type alias Model =
    { input : String
    , memos : List String
    }

init : Model
init =
    { input = ""
    , memos = []
    }

-- UPDATE

type Msg
    = Input String
    | Submit
    | Delete

update : Msg -> Model -> Model
update msg model =
    case msg of
        Input input ->
            -- 入力文字列を更新する
            { model | input = input }

        Submit ->
            { model
                | input = ""
                , memos = model.input :: model.memos
            }

        Delete ->
            { model
                | memos = model.memos |> List.drop 1  }

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit Submit ]
            [ input [ value model.input, onInput (\s -> Input s) ] []
            , button
                [ disabled (String.length model.input < 1) ]
                [ text "Submit" ]
            ]
        , Html.form [ onSubmit Delete ] [ button [ disabled (List.length model.memos < 1) ] [ text "Delete" ] ]
        , ul [] (List.map viewMemo model.memos)
        ]

viewMemo : String -> Html Msg
viewMemo memo =
    li [] [ text memo ]