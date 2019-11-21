import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.11
import com.imagemonkeyhunt.imagemonkeyhunt 1.0
import "../basiccomponents"
import "../items"

BlankScreen {
    id: tasksScreen
    objectName: "Homescreen"

    Rectangle {
        anchors.fill: parent
        color: colorPalette.backgroundColor

        Pane {
            id: header
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 30 * settings.pixelDensity
            Material.background: "black"
            Text {
                id: headerText
                text: qsTr("The Game")
                font.family: adventuresFontLoader.name
                font.pixelSize: 10 * settings.pixelDensity
                anchors.centerIn: parent
                color: "white"
            }

            Text {
                id: stars
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: starsText.left
                anchors.rightMargin: 1 * settings.pixelDensity
                text: "\ue838"
                font.family: materialDesignLoader.name
                font.pixelSize: 10 * settings.pixelDensity
                color: "white"
                visible: false
            }

            Text {
                id: starsText
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -1 * settings.pixelDensity
                text: "10"
                font.family: adventuresFontLoader.name
                font.pixelSize: 10 * settings.pixelDensity
                color: "white"
                visible: false
            }
        }

        TabBar {
            id: homeScreenTabbar
            anchors.top: header.bottom
            Material.background: "black"
            Material.foreground: "white"
            Material.accent: "white"
            width: parent.width
            visible: true
            Component.onCompleted: {
                homeScreenTabbar.currentIndex = 0;
                tasksItem.isActive();
            }

            TabButton {
                text: qsTr("Tasks")
                font.family: adventuresFontLoader.name
                font.pixelSize: 7 * settings.pixelDensity
            }
            TabButton {
                text: qsTr("Badges")
                font.family: adventuresFontLoader.name
                font.pixelSize: 7 * settings.pixelDensity
            }
            TabButton {
                text: qsTr("Rules")
                font.family: adventuresFontLoader.name
                font.pixelSize: 7 * settings.pixelDensity
            }
        }

        StackLayout {
            id: homeScreenStackLayout
            anchors.top: homeScreenTabbar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: parent.width
            currentIndex: homeScreenTabbar.currentIndex
            TasksItem{
                id: tasksItem
                objectName: "TasksItem"
                onTaskCompleted: {
                    starsText.text = parseInt(starsText.text) + 1;
                }
            }
            StatsItem{
                id: statsItem
                objectName: "StatsItem"
            }
            AboutItem{
                id: aboutItem
                objectName: "AboutItem"
            }
            onCurrentIndexChanged: {
                homeScreenStackLayout.itemAt(currentIndex).isActive();
            }
        }

    }
}
