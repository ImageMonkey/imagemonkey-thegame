import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import com.imagemonkeyhunt.imagemonkeyhunt 1.0
import "../basiccomponents"

BlankItem {
    id: tasksItem
    objectName: "TasksItem"
    signal taskCompleted()

    QtObject {
        id: internalState
        property bool statsPopulated: false;
        property bool tasksPopulated: false;
    }

    onIsActive: {
        if(!internalState.statsPopulated && !internalState.tasksPopulated)
            pulsatingLogo.show();

        if(!internalState.tasksPopulated)
            restAPI.getTasks();

        if(!internalState.statsPopulated)
            restAPI.getStats();
    }


    HttpsRequestWorkerThread{
        id: restAPI
        signal getTasks();
        signal getStats();

        onGetTasks: {
            var tasksRequest = Qt.createQmlObject('import com.imagemonkeyhunt.imagemonkeyhunt 1.0; GetTasksRequest{}',
                                                               restAPI);
            tasksRequest.setUsername(settings.username);
            tasksRequest.setJWT(settings.jwt);
            tasksRequest.setRequestId("tasks");
            tasksRequest.setAllowedHTTPStatusCodes([403]);
            restAPI.get(tasksRequest);
        }

        onGetStats: {
            var statsRequest = Qt.createQmlObject('import com.imagemonkeyhunt.imagemonkeyhunt 1.0; GetStatsRequest{}',
                                                               restAPI);
            statsRequest.setUsername(settings.username);
            statsRequest.setJWT(settings.jwt);
            statsRequest.setRequestId("stats");
            restAPI.get(statsRequest);
        }
    }

    Connections {
        target: restAPI
        onResultReady: {
            if(errorCode === 0) {
                if(uniqueRequestId === "tasks")
                    populateTasksList(JSON.parse(result), false);

                if(uniqueRequestId === "stats")
                    setStats(JSON.parse(result));

                if(internalState.tasksPopulated && internalState.statsPopulated) {
                    pulsatingLogo.hide();
                    loadingIndicator.visible = false;
                }
            } else {
                if(statusCode === 403) {
                    settings.username = "";
                    settings.jwt = "";
                    stackView.replace(Qt.resolvedUrl("qrc:/source/qml/screens/LoginScreen.qml"));
                }
            }
        }
    }

    function updateEntry(label, imageData) {
        for(var i = 0; i < tasksModel.count; i++) {
            if(tasksModel.get(i).getLabel() === label) {
                tasksModel.get(i).setImageData(imageData);
                tasksModel.update(i);
                break;
            }
        }
    }

    function setStats(data) {
        if("stars" in data) {
            starsText.text = data.stars;
            stars.visible = true;
            starsText.visible = true;
        }
        internalState.statsPopulated = true;
    }

    function populateTasksList(data, clearBefore) {
        if(clearBefore)
            tasksModel.clear();

        for(var i = 0; i < data.length; i++) {
            var entry = Qt.createQmlObject('import com.imagemonkeyhunt.imagemonkeyhunt 1.0; Task{}',
                                           tasksModel);
            entry.setLabel(data[i].label.name);
            entry.setLabelAccessor(data[i].label.accessor);

            if("image" in data[i]) {
                var imageUrl = data[i].image.url;
                if(!data[i].image.unlocked)
                    imageUrl += "?token=" + settings.jwt;
                entry.setImageUrl(imageUrl);
            }
            tasksModel.addTask(entry);
        }
        internalState.tasksPopulated = true;
    }

    TasksModel {
        id: tasksModel
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
            id: tasksList
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 15 * settings.pixelDensity
            model: tasksModel
            spacing: 5 * settings.pixelDensity
            clip: true
            Component.onCompleted: {
                if(Qt.platform.os === "android") {
                    if(settings.pixelDensity > 1)
                        tasksList.maximumFlickVelocity = tasksList.maximumFlickVelocity * settings.pixelDensity;
                }
            }

            delegate: Item {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5 * settings.pixelDensity
                anchors.rightMargin: 5 * settings.pixelDensity
                height: 30 * settings.pixelDensity


                Pane {
                    anchors.fill: parent
                    Material.background: colorPalette.secondaryColor
                    Material.elevation: 8
                    visible: true
                    opacity: ((model.base64ImageData === "") && (model.imageUrl === "")) ? 1.0 : 0.5
                }

                Text {
                    id: labelName
                    font.family: adventuresFontLoader.name
                    text: model.label
                    font.pixelSize: 8 * settings.pixelDensity
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        stackView.push(Qt.resolvedUrl("qrc:/source/qml/screens/CameraScreen.qml"));
                        stackView.currentItem.label = model.label;
                        stackView.currentItem.process.connect(processCapturedImage);
                    }

                    function processCapturedImage(label, img) {
                        tasksItem.updateEntry(label, img);
                        tasksItem.taskCompleted();
                        stackView.pop();
                    }
                }
            }
        }
    }
}
