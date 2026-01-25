import QtQuick
import QtQuick.Controls

SpinBox {
    id: spinBox
    width: Metrics.spinBoxWidth
    height: Metrics.controlHeight
    stepSize: 10
    from: 0
    to: 1000

    function setFrom(newFrom) { spinBox.from = newFrom }
    function setTo(newTo) { spinBox.to = newTo }
    function setValue(newValue) { spinBox.value = newValue }

    contentItem: TextInput {
        text: spinBox.value
        font.pixelSize: 18
        font.family: Typography.fontBold
        color: Theme.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        selectionColor: Theme.themeColor
        selectByMouse: true
        selectedTextColor: Theme.hoverTextColor
        validator: IntValidator {
            bottom: spinBox.from
            top: spinBox.to
        }
        onTextChanged: {
            if (text !== "" && !isNaN(parseInt(text, 10))) {
                spinBox.value = parseInt(text, 10)
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.IBeamCursor
            acceptedButtons: Qt.NoButton
            enabled: true
        }
    }

    background: Rectangle {
        anchors.fill: parent
        radius: Metrics.radiusM
        color: Theme.backgroundColor
        border.color: Theme.borderColor
        border.width: Metrics.borderThick
    }

    up.indicator: Rectangle {
        x: spinBox.width - width
        height: spinBox.height / 2
        width: Metrics.iconSizeL
        color: Theme.backgroundColor
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Metrics.marginS
        anchors.rightMargin: Metrics.marginS

        Text {
            text: "▴"
            anchors.centerIn: parent
            color: upMouseArea.containsMouse ? Theme.themeColor : Theme.textColor
            font.pixelSize: Typography.bigFontSize
        }

        MouseArea {
            id: upMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: spinBox.increase()
        }
    }

    down.indicator: Rectangle {
        width: Metrics.iconSizeL
        height: spinBox.height / 2
        color: Theme.backgroundColor
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: Metrics.marginS
        anchors.rightMargin: Metrics.marginS

        Text {
            text: "▾"
            anchors.centerIn: parent
            color: downMouseArea.containsMouse ? Theme.themeColor : Theme.textColor
            font.pixelSize: Typography.bigFontSize
        }

        MouseArea {
            id: downMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: spinBox.decrease()
        }
    }
}
