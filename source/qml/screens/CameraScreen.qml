import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtMultimedia 5.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import com.imagemonkeyhunt.imagemonkeyhunt 1.0
import "../basiccomponents"

BlankScreen {
    id: cameraScreen
    signal process(string label, var imageData)
    property bool previewMode: false;
    property string label: "";
    property var compressedImage;
    property File qmlFile: File{}
    objectName: "CameraScreen"

    function initialize(parameters) {
        for (var attr in parameters) {
            editImageScreen[attr] = parameters[attr]
        }
    }


    HttpsRequestWorkerThread{
        id: restAPI
        signal donate(string label);

        onDonate: {
            loadingIndicator.visible = true;
            var donateAndLabelImageRequest = Qt.createQmlObject('import com.imagemonkeyhunt.imagemonkeyhunt 1.0; DonateImageAndLabel{}',
                                                                restAPI);
            cameraScreen.compressedImage = imageProcessor.compress(1024, 768, 85, "jpeg");
            donateAndLabelImageRequest.set(cameraScreen.compressedImage, label);
            donateAndLabelImageRequest.setJWT(settings.jwt);
            restAPI.post(donateAndLabelImageRequest);
        }
    }

    Connections {
        target: restAPI
        onResultReady: {
            if(errorCode === 0) {
                loadingIndicator.visible = false;
                cameraScreen.process(cameraScreen.label, cameraScreen.compressedImage);

            } else {
                if(statusCode === 409)
                    infoToast.show(qsTr("Image already exists"), 2000);
                else
                    infoToast.show(qsTr("Couldn't upload image"), 2000);
                loadingIndicator.visible = false;
            }
        }
    }


    ImageProcessor{
        id: imageProcessor
    }

    Camera {
        id: camera

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposureLandscape
        }

        flash.mode: Camera.FlashRedEyeReduction

        imageCapture {
            onImageCaptured: {
                photoPreview.source = preview;
                imageProcessor.setImage(preview);
            }
            onImageSaved: {
                //after image was created, delete image from filesystem
                //this is currently a workaround, as there seems to be no
                //easy and portable solution to capture a image only in memory.
                //tried to use QVideoProbe, but unfortunately this only works
                //for Android. see (http://lists.qt-project.org/pipermail/interest/2014-February/011125.html)
                qmlFile.source = path;
                qmlFile.remove();
            }
        }
    }

    CloseButtonMenuBar{
        id: menuBar
        name: qsTr("Take Picture")
        description: cameraScreen.label
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        onClicked: stackView.pop(); //cameraScreen.process(null);
    }

    Rectangle{
        color: colorPalette.backgroundColor
        anchors.top: menuBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom



        VideoOutput {
            id: prev
            source: camera
            anchors.fill: parent
            focus : visible // to receive focus and capture key events when visible
            autoOrientation: true //auto rotate video preview according on how the camera pos is mounted on the device
            visible: !cameraScreen.previewMode
            fillMode: Image.PreserveAspectCrop

        }

        Image {
            id: photoPreview
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            visible: cameraScreen.previewMode
        }

        RoundButton {
            id: takePictureButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15 * settings.pixelDensity
            width: 20 * settings.pixelDensity
            height: width
            text: "\ue412"
            opacity: 1
            font.pixelSize: 8 * settings.pixelDensity
            visible: !cameraScreen.previewMode
            Material.background: colorPalette.secondaryColor
            onClicked: {
                camera.imageCapture.capture();
                cameraScreen.previewMode = true; //we are now in preview mode
            }
        }

        RowLayout {
            id: layout
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15 * settings.pixelDensity
            spacing: 10 * settings.pixelDensity

            RoundButton{
                id: tryAgainButton
                Layout.preferredHeight: 20 * settings.pixelDensity
                Layout.preferredWidth: 20 * settings.pixelDensity
                Layout.maximumHeight: 20 * settings.pixelDensity
                Layout.maximumWidth: 20 * settings.pixelDensity
                height: 20 * settings.pixelDensity
                font.pixelSize: 8 * settings.pixelDensity
                Material.background: colorPalette.secondaryColor
                opacity: 1.0
                text: "\ue042"
                font.family: materialDesignLoader.name
                visible: cameraScreen.previewMode
                onClicked: cameraScreen.previewMode = false;
            }

            RoundButton{
                id: doneButton
                Layout.preferredHeight: 20 * settings.pixelDensity
                Layout.preferredWidth: 20 * settings.pixelDensity
                Layout.maximumHeight: 20 * settings.pixelDensity
                Layout.maximumWidth: 20 * settings.pixelDensity
                font.pixelSize: 8 * settings.pixelDensity
                height: 20 * settings.pixelDensity
                Material.background: colorPalette.secondaryColor
                opacity: 1.0
                visible: cameraScreen.previewMode
                text: "\ue877"
                font.family: materialDesignLoader.name
                onClicked: {
                    restAPI.donate(cameraScreen.label);

                }
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
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2 * settings.pixelDensity
        }
    }
}

