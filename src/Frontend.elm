module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Lamdera exposing (sendToBackend)
import PortDefs exposing (jsonify)
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , message = "Welcome to Lamdera! You're looking at the auto-generated base implementation. Check out src/Frontend.elm to start coding!"
      , debugState = Nothing
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        UserClickedMessageCode int ->
            case int of
                1 ->
                    ( model, sendToBackend MessageType1 )

                2 ->
                    ( model, sendToBackend MessageType2 )

                3 ->
                    ( model, sendToBackend MessageType3 )

                4 ->
                    ( model, sendToBackend MessageType4 )

                _ ->
                    -- noop
                    ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        UpdateDebugger backendModel ->
            ( { model | debugState = Just backendModel }
            , Cmd.none
            )


view : Model -> Browser.Document FrontendMsg
view model =
    { title = "Debugger hacking"
    , body = [ layout [ width fill, height fill ] (viewElement model) ]
    }


viewElement : Model -> Element FrontendMsg
viewElement model =
    let
        attrs : Int -> List (Attribute FrontendMsg)
        attrs code =
            [ width shrink
            , height shrink
            , Events.onClick (UserClickedMessageCode code)
            , Background.color (rgb 100 100 100)
            , Border.width 1
            , Border.color (rgb 0 0 0)
            , Border.rounded 5
            , pointer
            , centerX
            , mouseDown [ Background.color (rgb 150 150 150) ]
            ]
    in
    column
        [ width (fill |> minimum 400 |> maximum 800)
        , height fill
        , spacing 10
        , centerX
        , Border.width 1
        , Border.color (rgb 0 0 0)
        ]
        [ text "Debugger hacking: Click a button to send a message to the backend."
        , el (attrs 1) <| text "Click to send message type 1 to backend"
        , el (attrs 2) <| text "Click to send message type 2 to backend"
        , el (attrs 3) <| text "Click to send message type 3 to backend"
        , el (attrs 4) <| text "Click to send message type 4 to backend"
        , column [ width fill ]
            [ paragraph [] [ text <| Debug.toString model.debugState ]
            ]
        ]
