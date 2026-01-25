import QtQuick
import QtQuick.Controls

ComboBox {
    id: control
    width: Metrics.comboBoxWidth
    height: Metrics.controlHeight
    hoverEnabled: true
    property int optionHeight: Metrics.controlHeightCompact
    property int popupPadding: 6

    contentItem: Text {
        text: control.displayText !== "" ? control.displayText : "Select"
        anchors.fill: parent
        font.pixelSize: Typography.hugeFontSize
        font.family: Typography.fontBold
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: mouseArea.containsMouse
               ? Theme.hoverTextColor
               : Theme.textColor

        Behavior on color { ColorAnimation { duration: 150 } }
    }

    indicator: Text {
        text: "▾"
        color: contentItem.color
        font.pixelSize: Typography.iconFontSize
        anchors.right: parent.right
        anchors.rightMargin: Metrics.marginM
        anchors.verticalCenter: parent.verticalCenter
    }

    background: Rectangle {
        anchors.fill: parent
        radius: Metrics.radiusM
        border.color: Theme.borderColor
        border.width: Metrics.borderThick
        color: mouseArea.containsMouse
               ? Theme.hoverBackgroundColor
               : Theme.backgroundColor
        Behavior on color { ColorAnimation { duration: 150 } }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: control.open()
        }
    }

    popup: Popup {
        width: control.width
        implicitHeight: control.count * control.optionHeight + control.popupPadding * 2

        padding: 0
        topPadding: 0
        bottomPadding: 0
        leftPadding: 0
        rightPadding: 0

        background: Rectangle {
            radius: Metrics.radiusM
            color: Theme.backgroundColor
            border.color: Theme.borderColor
            border.width: Metrics.borderThick
        }

        Column {
            anchors.fill: parent
            anchors.margins: control.popupPadding
            spacing: 0

            Repeater {
                model: control.model

                delegate: Rectangle {
                    width: parent.width
                    height: control.optionHeight
                    radius: Metrics.radiusM
                    color: hovered
                           ? Theme.hoverBackgroundColor
                           : "transparent"

                    property bool hovered: false

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                        onClicked: {
                            control.currentIndex = index
                            control.popup.close()
                        }
                    }

                    Text {
                        anchors.fill: parent
                        text: control.textRole ? model[control.textRole] : modelData
                        font.pixelSize: Typography.hugeFontSize
                        font.family: Typography.fontBold
                        color: hovered ? Theme.hoverTextColor : Theme.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
