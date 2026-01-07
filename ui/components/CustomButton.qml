import QtQuick

Rectangle {
    id: convertButton
    width: 120
    height: 40
    radius: 6
    color: mouseArea.containsMouse ? "#B4B4B4" : "#2A2A2A"
    signal pressed
    property string buttonText

    Keys.onReturnPressed: doPress()
    Keys.onEnterPressed: doPress()

    function doPress() {
        pressed()
    }

    Text {
        anchors.centerIn: parent
        text: convertButton.buttonText
        font.pixelSize: 18
        font.family: "JetBrains Mono"
        font.bold: true
        color: mouseArea.containsMouse ? "#2A2A2A" : "#B4B4B4"

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: convertButton.doPress()
    }

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
}
