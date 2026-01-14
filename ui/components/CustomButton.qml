import QtQuick

Rectangle {
    id: convertButton
    width: 180
    height: 40
    radius: 6
    border.color: Data.borderColor
    border.width: 3
    color: mouseArea.containsMouse ? Data.hoverBackgroundColor : Data.backgroundColor
    signal pressed
    property string buttonText

    Keys.onReturnPressed: doPress()
    Keys.onEnterPressed: doPress()

    function doPress() {
        pressed();
    }

    Text {
        anchors.centerIn: parent
        text: convertButton.buttonText
        font.pixelSize: 18
        font.family: Data.fontBold
        color: mouseArea.containsMouse ? Data.hoverTextColor : Data.textColor

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
