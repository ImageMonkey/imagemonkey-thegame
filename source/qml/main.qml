import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Window 2.2
import com.imagemonkeyhunt.imagemonkeyhunt 1.0
import "screens"

ApplicationWindow {
    visible: true
    width: 640
    height: 800
    title: qsTr("ImageMonkey The Game")

    Component.onCompleted: {
        settings.pixelDensity = Screen.logicalPixelDensity //set pixel density
        if((settings.jwt === "") || (settings.username === "")) {
            stackView.replace(Qt.resolvedUrl("qrc:/source/qml/screens/LoginScreen.qml"));
            stackView.currentItem.loginSuccessful.connect(onSuccessfulLogin);
        } else {
            onSuccessfulLogin();
        }
    }

    function onSuccessfulLogin() {
        stackView.replace(Qt.resolvedUrl("qrc:/source/qml/screens/HomeScreen.qml"));
    }

    QtObject{
        id: settings
        property double pixelDensity
        property string username: ""
        property string jwt: keyChain.getJwt()
        onJwtChanged: keyChain.setJwt(settings.jwt);
    }

    Keychain{
        id: keyChain
        property alias jwt: settings.jwt
    }


    Settings {
        category: "General"
        property alias username: settings.username
    }

    StackView {
        id: stackView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        onCurrentItemChanged: {
            if(currentItem !== null)
                currentItem.isActive()
        }
    }

    QtObject {
        id: colorPalette
        property string backgroundColor: "#004847"//"#0a0a0a"
        property string foregroundColor: "#00ffff"
        property string secondaryColor: "orange" // "#D17D19"
        property string secondaryColorLight: "#027B87"
    }


    FontLoader{
        id: materialDesignLoader
        source: "../fonts/material-design-icons.ttf"
    }

    FontLoader{
        id: adventuresFontLoader
        source: "../fonts/KOMIKAX_.ttf"
    }

    FontLoader{
        id: fontawesomeLoader
        source: "../fonts/fontawesome-webfont.ttf"
    }
}
