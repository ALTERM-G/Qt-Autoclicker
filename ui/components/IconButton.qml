import QtQuick
import QtQuick.Controls

Rectangle {
    id: iconButton
    property string iconPath: ""
    width: Metrics.iconSizeM
    height: Metrics.iconSizeM
    color: "transparent"
    signal pressed
    Keys.onReturnPressed: doPress()
    Keys.onEnterPressed: doPress()
    function doPress() { pressed(); }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: iconButton.doPress()
    }

    SVGObject {
        id: iconSvg
        anchors.centerIn: parent
        path: iconPath
        width: Metrics.iconSizeM
        height: Metrics.iconSizeM
        color: mouseArea.containsMouse ? Theme.themeColor() : Theme.textColor()

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    scale: mouseArea.containsMouse ? 1.1 : 1.0
    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }
}
