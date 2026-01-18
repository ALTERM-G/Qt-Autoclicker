import QtQuick

Rectangle {
    id: convertButton
    width: 150
    height: 40
    radius: 6
    border.color: Data.borderColor
    border.width: 3
    color: mouseArea.containsMouse ? Data.hoverBackgroundColor : Data.backgroundColor
    signal pressed
    property string buttonText
    property bool run: false
    property string iconSource: ""
    property string hoverIconSource: ""
    Keys.onReturnPressed: doPress()
    Keys.onEnterPressed: doPress()
    function doPress() {
        pressed();
    }

    Row {
        anchors.centerIn: parent
        spacing: 8

        Image {
            id: buttonIcon
            source: mouseArea.containsMouse ? (hoverIconSource || iconSource) : iconSource
            visible: iconSource !== ""
            sourceSize: Qt.size(20, 20)
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: convertButton.buttonText
            font.pixelSize: 18
            font.family: Data.fontBold
            color: mouseArea.containsMouse ? Data.hoverTextColor : Data.textColor
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
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
