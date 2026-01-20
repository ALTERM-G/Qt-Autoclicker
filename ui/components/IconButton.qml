import QtQuick
import QtQuick.Controls

Rectangle {
    id: iconButton
    property string iconPath: ""
    property string hoverIconPath: ""
    width: 40
    height: 40
    color: "transparent"
    signal pressed
    Keys.onReturnPressed: doPress()
    Keys.onEnterPressed: doPress()
    function doPress() {
        pressed();
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: iconButton.doPress()
    }

    Image {
        source: mouseArea.containsMouse
                ? hoverIconPath
                : iconPath
        sourceSize: Qt.size(width, height)
        anchors.centerIn: parent
        width: 40
        height: 40
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    scale: mouseArea.containsMouse ? 1.1 : 1.0

    Behavior on scale {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }
}
