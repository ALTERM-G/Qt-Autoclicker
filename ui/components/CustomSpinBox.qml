import QtQuick
import QtQuick.Controls

SpinBox {
    id: spinBox
    width: 120
    height: 40
    stepSize: 10
    from: 0
    to: 1000

    function setFrom(newFrom) { spinBox.from = newFrom }
    function setTo(newTo) { spinBox.to = newTo }
    function setValue(newValue) { spinBox.value = newValue }

    contentItem: TextInput {
        text: spinBox.value
        font.pixelSize: 18
        font.family: Theme.fontBold
        color: Theme.textColor()
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        selectionColor: Theme.themeColor()
        selectByMouse: true
        selectedTextColor: "#000000"
        validator: IntValidator {
            bottom: spinBox.from
            top: spinBox.to
        }
        onEditingFinished: {
            if (text !== "") {
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
        radius: 6
        color: Theme.backgroundColor()
        border.color: Theme.borderColor()
        border.width: 3
    }

    up.indicator: Rectangle {
        x: spinBox.width - width
        height: spinBox.height / 2
        width: 30
        color: Theme.backgroundColor()
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 3
        anchors.rightMargin: 3

        Text {
            text: "▴"
            anchors.centerIn: parent
            color: upMouseArea.containsMouse ? Theme.themeColor() : Theme.textColor()
            font.pixelSize: 16
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
        width: 30
        height: spinBox.height / 2
        color: Theme.backgroundColor()
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 3
        anchors.rightMargin: 3

        Text {
            text: "▾"
            anchors.centerIn: parent
            color: downMouseArea.containsMouse ? Theme.themeColor() : Theme.textColor()
            font.pixelSize: 14
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
