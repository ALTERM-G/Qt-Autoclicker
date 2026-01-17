import QtQuick
import QtQuick.Controls

ComboBox {
    id: control
    width: 200
    height: 40
    hoverEnabled: true

    contentItem: Text {
        id: contentText
        text: control.displayText !== "" ? control.displayText : "Select"
        anchors.fill: parent
        font.pixelSize: 18
        font.family: Data.fontBold
        color: mouseArea.containsMouse ? Data.hoverTextColor : Data.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    indicator: Text {
        text: "▾"
        color: contentText.color
        font.pixelSize: 24
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }

    background: Rectangle {
        anchors.fill: parent
        radius: 6
        color: mouseArea.containsMouse ? Data.hoverBackgroundColor : Data.backgroundColor
        border.color: Data.borderColor
        border.width: 3

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }

        MouseArea {
            id: mouseArea
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: control.open()
        }
    }

    popup: Popup {
        width: control.width
        implicitHeight: control.count * 50

        background: Rectangle {
            radius: 6
            color: Data.backgroundColor
            border.color: Data.borderColor
            border.width: 3
        }

        Column {
            anchors.fill: parent
            spacing: 0

            Repeater {
                model: control.model

                delegate: ItemDelegate {
                    id: itemDelegate
                    width: parent ? parent.width : 200
                    height: 43

                    contentItem: Text {
                        text: control.textRole ? model[control.textRole] : modelData
                        font.pixelSize: 18
                        font.family: Data.fontBold
                        color: itemDelegate.hovered ? Data.hoverTextColor : Data.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        anchors.fill: parent
                        color: itemDelegate.hovered ? Data.themeColor : "transparent"
                        radius: 6
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            control.currentIndex = index
                            control.popup.close()
                        }
                    }
                }
            }
        }
    }
}
