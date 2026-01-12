import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "components"
import Data 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 450
    height: 600
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height
    title: "Autoclick and shortcut_manager"
    Rectangle {
        id: background
        anchors.fill: parent
        color: "#101010"

        Rectangle {
            id: topBar
            height: 75
            color: "#060606"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            Rectangle {
                id: border
                height: 2
                color: "#333333"
                width: parent.width
                anchors.bottom: parent.bottom
            }
        }

        Text {
            id: title_ASCII
            color: "#E78C02"
            anchors.left: topBar.left
            anchors.verticalCenter: topBar.verticalCenter
            anchors.leftMargin: 10
            height: topBar.height
            text:
                " █████╗ ██╗   ██╗████████╗ ██████╗        ██████╗██╗     ██╗ ██████╗██╗  ██╗\n" +
                "██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗      ██╔════╝██║     ██║██╔════╝██║ ██╔╝\n" +
                "███████║██║   ██║   ██║   ██║   ██║█████╗██║     ██║     ██║██║     █████╔╝ \n" +
                "██╔══██║██║   ██║   ██║   ██║   ██║╚════╝██║     ██║     ██║██║     ██╔═██╗ \n" +
                "██║  ██║╚██████╔╝   ██║   ╚██████╔╝      ╚██████╗███████╗██║╚██████╗██║  ██╗\n" +
                "╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝        ╚═════╝╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝"

            font.pointSize: 4
            font.family: Data.fontRegular
            wrapMode: Text.NoWrap
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        CustomButton {
            id: button
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            buttonText: "Test0"
        }

        CustomComboBox {
            id: comboBox
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: button.bottom
            anchors.bottomMargin: 60
            buttonText: "Test0"
        }

        AppRect {
            id: appRect
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: comboBox.bottom
            anchors.bottomMargin: 60
            width: 200
            height: 100
        }
    }
}
