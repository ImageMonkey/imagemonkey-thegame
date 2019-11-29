import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import com.imagemonkeyhunt.imagemonkeyhunt 1.0
import "../basiccomponents"

BlankItem {
    id: statsItem

    QtObject {
        id: internalState
        property bool statsPopulated: false;
    }

    onIsActive: {
        if(!internalState.statsPopulated)
            restAPI.getStats();
    }

    HttpsRequestWorkerThread{
        id: restAPI
        signal getStats();

        onGetStats: {
            var timezoneOffset = new Date().getTimezoneOffset() * 60;

            var statsRequest = Qt.createQmlObject('import com.imagemonkeyhunt.imagemonkeyhunt 1.0; GetStatsRequest{}',
                                                               restAPI);
            statsRequest.setUsername(settings.username);
            statsRequest.setOffsetFromUtc(timezoneOffset);
            statsRequest.setJWT(settings.jwt);
            statsRequest.setRequestId("stats");
            restAPI.get(statsRequest);
        }
    }

    Connections {
        target: restAPI
        onResultReady: {
            if(errorCode === 0) {
                setStats(JSON.parse(result));
                pulsatingLogo.hide();
                loadingIndicator.visible = false;
            } else {
                if(statusCode === 403) {
                    settings.username = "";
                    settings.jwt = "";
                    stackView.replace(Qt.resolvedUrl("qrc:/source/qml/screens/LoginScreen.qml"));
                }
            }
        }
    }

    function setStats(data) {
        var achievements = data.achievements;
        for(var i = 0; i < achievements.length; i++) {
            statsModel.append({"name": achievements[i].name, "description": achievements[i].description,
                                   "accomplished": achievements[i].accomplished,
                                   "badge": achievements[i].badge});
        }
        internalState.statsPopulated = true;
    }

    ListModel {
         id: statsModel
    }


    Rectangle {
        anchors.fill: parent
        color: colorPalette.backgroundColor

        PulsatingLogo{
            id: pulsatingLogo
            anchors.centerIn: parent
            width: parent.width/2.5
            height: width
            z: 5
        }

        ProgressLoadingBar {
            id: loadingIndicator
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            visible: false
        }

        ListView {
            id: statsList
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 15 * settings.pixelDensity
            model: statsModel
            spacing: 5 * settings.pixelDensity
            clip: true

            Component.onCompleted: {
                if(Qt.platform.os === "android") {
                    if(settings.pixelDensity > 1)
                        statsList.maximumFlickVelocity = statsList.maximumFlickVelocity * settings.pixelDensity;
                }
            }

            delegate: Item {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5 * settings.pixelDensity
                anchors.rightMargin: 5 * settings.pixelDensity
                height: 25 * settings.pixelDensity


                Pane {
                    id: pane
                    anchors.fill: parent
                    Material.background: colorPalette.secondaryColor
                    Material.elevation: 8
                    visible: true
                    opacity: (accomplished === true) ? 1.0 : 0.4
                }

                Image {
                    id: achievementBadge
                    source: badge
                    anchors.left: parent.left
                    anchors.leftMargin: 2 * settings.pixelDensity
                    anchors.verticalCenter: parent.verticalCenter
                    height: 18 * settings.pixelDensity
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    id: achivementName
                    font.family: adventuresFontLoader.name
                    text: name
                    font.pixelSize: 7 * settings.pixelDensity
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: achivementDescription.top
                    anchors.verticalCenterOffset: -5 * settings.pixelDensity
                }


                Text {
                    id: achivementDescription
                    font.family: adventuresFontLoader.name
                    text: description
                    font.pixelSize: 3 * settings.pixelDensity
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2 * settings.pixelDensity
                    width: pane.width - (45 * settings.pixelDensity)
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap

                }

            }

        }
    }
}
