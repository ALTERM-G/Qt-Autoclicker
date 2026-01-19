import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

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
        height: 420
        parent: Overlay.overlay
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        transformOrigin: Item.Center

        enter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    property: "scale"
                    from: 0.8
                    to: 1
                    duration: 200
                    easing.type: Easing.OutBack
                }
            }
        }

        exit: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 160
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    property: "scale"
                    from: 1
                    to: 0.85
                    duration: 160
                    easing.type: Easing.InQuad
                }
            }
        }

        background: AppRect {
            anchors.fill: parent

            ColumnLayout {
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter

                CustomText {
                    text: "Settings"
                    Layout.alignment: Qt.AlignHCenter
                }

                CustomText {
                    text: "Run Shortcut"
                    style_2: true
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    Layout.topMargin: 15
                }

                CustomShortcutEditor {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 2
                    shortcutType: "run"
                }

                CustomText {
                    text: "Stop shortcut"
                    style_2: true
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    Layout.topMargin: 15
                }

                CustomShortcutEditor {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 2
                    shortcutType: "stop"
                }
            }
        }
    }
}
