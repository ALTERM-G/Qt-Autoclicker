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
        parent: Overlay.overlay
        modal: false
        focus: true
        closePolicy: Popup.CloseOnEscape
        width: 400
        height: 300
        anchors.centerIn: parent
        background: AppRect {
            anchors.fill: parent

            CustomText {
                text: "Settings"
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
