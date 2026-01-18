import QtQuick
import QtQuick.Controls

Item {
    id: settingsMenu
    width: 40
    height: 40

    Rectangle {
        id: buttonRect
        width: 40
        height: 40
        color: "transparent"

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (settingsPopup.opened)
                    settingsPopup.close()
                else
                    settingsPopup.open()
            }
        }

        Image {
            source: mouseArea.containsMouse
                    ? "../../assets/icons/settings_hover.svg"
                    : "../../assets/icons/settings.svg"
            anchors.centerIn: parent
            sourceSize: Qt.size(40, 40)
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
    }

    Popup {
        id: settingsPopup
        width: 400
        height: 300
        parent: Overlay.overlay
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        visible: false
        opacity: 0
        scale: 0.8
        Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
        Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

        onOpened: {
            settingsPopup.visible = true
            settingsPopup.opacity = 1
            settingsPopup.scale = 1
        }
        onClosed: {
            settingsPopup.opacity = 0
            settingsPopup.scale = 0.8
            Qt.callLater(() => settingsPopup.visible = false)
        }

        background: AppRect {
            anchors.fill: parent
            CustomText {
                text: "Settings"
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }

            CustomShortcutEditor {
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
