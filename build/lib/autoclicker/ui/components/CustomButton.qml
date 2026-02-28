import QtQuick

Rectangle {
    id: convertButton
    width: Metrics.buttonWidth
    height: Metrics.controlHeight
    radius: Metrics.radiusM
    border.color: Theme.borderColor
    border.width: Metrics.borderThick
    color: mouseArea.containsMouse ? Theme.hoverBackgroundColor : Theme.backgroundColor
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
        spacing: Metrics.spacingS

        SVGObject {
            id: buttonIcon
            anchors.verticalCenter: parent.verticalCenter
            path: convertButton.iconPath
            visible: convertButton.iconPath !== ""
            width: Metrics.iconSizeS
            height: Metrics.iconSizeS
            color: mouseArea.containsMouse ? Theme.hoverTextColor : Theme.textColor
        }

        Text {
            text: convertButton.buttonText
            font.pixelSize: 18
            font.family: Typography.fontBold
            color: mouseArea.containsMouse ? Theme.hoverTextColor : Theme.textColor
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
