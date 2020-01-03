import Html exposing (Html, a, text)
import Html.Attributes exposing (href)

main : Html msg
main =
    a [ href "https://elm-lang.org" ] [ text "Elm" ]