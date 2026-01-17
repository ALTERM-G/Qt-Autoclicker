import QtQuick
import QtQuick.Controls

Rectangle {
    id: settingsButton
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
        onClicked: settingsButton.doPress()
    }

    Image {
        source: mouseArea.containsMouse
                ? "../../assets/icons/settings_hover.svg"
                : "../../assets/icons/settings.svg"
        sourceSize: Qt.size(width, height)
        anchors.centerIn: parent
        width: 40
        height: 40
        fillMode: Image.PreserveAspectFit
        smooth: true
    }
}
