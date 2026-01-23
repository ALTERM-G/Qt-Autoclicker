import QtQuick

Rectangle {
    id: convertButton
    width: 150
    height: 40
    radius: 6
    border.color: Theme.borderColor()
    border.width: 3
    color: mouseArea.containsMouse ? Theme.hoverBackgroundColor() : Theme.backgroundColor()
    signal pressed
    property string buttonText
    property bool run: false
    property string iconPath: ""
    Keys.onReturnPressed: doPress()
    Keys.onEnterPressed: doPress()
    function doPress() {
        pressed();
    }

    Row {
        anchors.centerIn: parent
        spacing: 8

        SVGObject {
            id: buttonIcon
            anchors.verticalCenter: parent.verticalCenter
            path: convertButton.iconPath
            visible: convertButton.iconPath !== ""
            width: 17
            height: 17
            color: mouseArea.containsMouse ? Theme.hoverTextColor() : Theme.textColor()
        }

        Text {
            text: convertButton.buttonText
            font.pixelSize: 18
            font.family: Theme.fontBold
            color: mouseArea.containsMouse ? Theme.hoverTextColor() : Theme.textColor()
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
