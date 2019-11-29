import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3

BlankItem {
    id: aboutItem

    Rectangle {
        anchors.fill: parent
        color: colorPalette.backgroundColor

        ListModel {
            id: rulesModel
            ListElement {
                name: qsTr("Respect people's privacy")
                description: qsTr("Do not upload photos that show other people's faces.")
                type: "success"
            }

            ListElement {
                name: qsTr("Only upload your own images")
                description: qsTr("Do not use google images ;-)")
                type: "success"
            }
            ListElement {
                name: qsTr("No Porn Please")
                description: qsTr("There are enough porn sites out there, this is not one!")
                type: "error"
            }
            ListElement {
                name: qsTr("Do not try to trick the system")
                description: qsTr("We will detect malicious attempts, so please don't do it.")
                type: "error"
            }
        }


        /*Text {
            id: rules
            anchors.top: parent.top
            anchors.topMargin: 7.5 * settings.pixelDensity
            anchors.horizontalCenter: parent.horizontalCenter

            text: qsTr("Rules")
            font.family: adventuresFontLoader.name
            font.pixelSize: 8 * settings.pixelDensity
            color: "black"

        }*/

        ListView {
            id: rulesList
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 5 * settings.pixelDensity
            model: rulesModel
            spacing: 5 * settings.pixelDensity
            clip: true

            Component.onCompleted: {
                if(Qt.platform.os === "android") {
                    if(settings.pixelDensity > 1)
                        rulesList.maximumFlickVelocity = rulesList.maximumFlickVelocity * settings.pixelDensity;
                }
            }

            delegate: Item {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5 * settings.pixelDensity
                anchors.rightMargin: 5 * settings.pixelDensity
                height: 25 * settings.pixelDensity


                Pane {
                    anchors.fill: parent
                    Material.background: (type === "error") ? "red": "green"
                    Material.elevation: 8
                    visible: true
                    opacity: 1.0
                }

                Text {
                    id: ruleName
                    font.family: adventuresFontLoader.name
                    text: name
                    font.pixelSize: 6.5 * settings.pixelDensity
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -2 * settings.pixelDensity
                }

                Text {
                    id: ruleDescription
                    font.family: adventuresFontLoader.name
                    text: description
                    font.pixelSize: 3 * settings.pixelDensity
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 2 * settings.pixelDensity
                }
            }
        }
    }


    /*Text {
        anchors.top: rules.bottom
        anchors.left: parent.left
        anchors.leftMargin: 5 * settings.pixelDensity
        textFormat: Text.RichText
        text: qsTr("<ul><li>Do not use google images</ul>")
    }*/
}
