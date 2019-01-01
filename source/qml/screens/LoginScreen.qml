import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import com.imagemonkeyhunt.imagemonkeyhunt 1.0
import "../basiccomponents"

BlankScreen {
    id: loginScreen
    signal loginSuccessful();

    HttpsRequestWorkerThread{
        id: restAPI
        signal login();

        onLogin: {
            var loginRequest = Qt.createQmlObject('import com.imagemonkeyhunt.imagemonkeyhunt 1.0; LoginRequest{}',
                                                  restAPI);
            loginRequest.setUsername(usernameInput.text);
            loginRequest.setPassword(passwordInput.text);
            restAPI.post(loginRequest);
        }
    }

    Connections {
        target: restAPI
        onResultReady: {
            if(errorCode === 0) {
                settings.jwt = JSON.parse(result)["token"];
                settings.username = usernameInput.text;
                loadingIndicator.visible = false;
                loginScreen.loginSuccessful();
            } else {
                if(statusCode === 401) {
                    infoToast.show("Username or password invalid", 2000);
                    loadingIndicator.visible = false;
                }
            }
        }
    }



    Flickable {
        id: flickable
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        contentWidth: background.width
        boundsBehavior: Flickable.StopAtBounds

        //when virtual keyboard is opened, make content by the virtual keyboard's height larger
        //contentHeight: Qt.inputMethod.visible ? (background.height + Qt.inputMethod.keyboardRectangle.height) : background.height
        //anchors.bottomMargin: Qt.inputMethod.visible ? 10 * settings.pixelDensity : 0
        flickableDirection: Flickable.VerticalFlick
        contentHeight: background.height
        clip: true

        Rectangle {
            id: background
            width: flickable.width
            height: flickable.height
            color: colorPalette.backgroundColor
            MouseArea {
                anchors.fill: parent
                onClicked: background.forceActiveFocus();
            }
        }


        Text {
            id: header
            anchors.top: logo.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("The Game")
            font.family: adventuresFontLoader.name
            font.pixelSize: 15 * settings.pixelDensity
            color: colorPalette.foregroundColor
        }

        Image {
            id: logo
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -40 * settings.pixelDensity
            width: parent.width/2.2
            source: "qrc:/images/logo2.png"
            fillMode: Image.PreserveAspectFit
        }

        TextField {
            id: usernameInput
            placeholderText: qsTr("Username")
            anchors.left: parent.left
            anchors.leftMargin: 5 * settings.pixelDensity
            anchors.right: parent.right
            anchors.rightMargin: 5 * settings.pixelDensity
            anchors.top: header.bottom
            anchors.topMargin: 5 * settings.pixelDensity
            width: parent.width
            Material.accent: colorPalette.foregroundColor
            Material.foreground: "white"
            font.pixelSize: 7 * settings.pixelDensity
        }

        TextField {
            id: passwordInput
            placeholderText: qsTr("Password")
            anchors.left: parent.left
            anchors.leftMargin: 5 * settings.pixelDensity
            anchors.right: parent.right
            anchors.rightMargin: 5 * settings.pixelDensity
            anchors.top: usernameInput.bottom
            anchors.topMargin: 5 * settings.pixelDensity
            width: parent.width
            Material.accent: colorPalette.foregroundColor
            Material.foreground: "white"
            font.pixelSize: 7 * settings.pixelDensity
            echoMode: TextInput.PasswordEchoOnEdit
        }

        Button {
            id: loginButton
            anchors.left: parent.left
            anchors.leftMargin: 5 * settings.pixelDensity
            anchors.right: parent.right
            anchors.rightMargin: 5 * settings.pixelDensity
            anchors.top: passwordInput.bottom
            anchors.topMargin: 10 * settings.pixelDensity
            width: parent.width
            height: 20 * settings.pixelDensity
            text: qsTr("LOGIN")
            font.pixelSize: 5.5 * settings.pixelDensity
            Material.background: colorPalette.secondaryColor
            Material.foreground: "white"

            onClicked: {
                loadingIndicator.visible = true;
                restAPI.login();
            }
        }

        ProgressLoadingBar {
            id: loadingIndicator
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            visible: false
        }

        Toast {
            id: infoToast
            anchors.top: loginButton.bottom
            anchors.topMargin: 2 * settings.pixelDensity
        }
    }
}
