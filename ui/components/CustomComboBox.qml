import QtQuick
import Data 1.0

Rectangle {
    id: convertButton
    width: 180
    height: 40
    radius: 6
    border.color: "#2B2B2B"
    border.width: 3
    color: mouseArea.containsMouse ? "#B4B4B4" : "#181818"
    signal pressed
    property string buttonText

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: convertButton.pressed()
    }

    Text {
        id: text
        anchors.centerIn: parent
        text: buttonText
        font.pixelSize: 18
        font.family: Data.fontBold
        color: mouseArea.containsMouse ? "#2A2A2A" : "#B4B4B4"
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }
}
