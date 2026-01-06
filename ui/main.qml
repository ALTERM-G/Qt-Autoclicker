import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Data 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 400
    height: 700
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
            border.color: "#333333"
            border.width: 2
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
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
            font.bold: true
            font.family: "JetBrains Mono"
            wrapMode: Text.NoWrap
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }
}
