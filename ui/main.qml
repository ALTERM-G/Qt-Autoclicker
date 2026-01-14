import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "components"

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
        color: Data.appBackgroundColor

        Rectangle {
            id: topBar
            height: 75
            color: Data.topBarColor
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            Rectangle {
                id: divider
                height: 2
                color: Data.dividerColor
                width: parent.width
                anchors.bottom: parent.bottom
            }
        }

        Text {
            id: title_ASCII
            color: Data.themeColor
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

        AppRect {
            id: appRect
            anchors.centerIn: parent
            anchors.topMargin: 100
            width: 400
            height: 300

            Column {
                anchors.fill: parent
                anchors.topMargin: 40
                spacing: 10

                CustomText {
                    id: customText
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Custom Text"
                }

                CustomButton {
                    id: button
                    anchors.horizontalCenter: parent.horizontalCenter
                    buttonText: "Test0"
                }

                CustomComboBox {
                    id: comboBox
                    anchors.horizontalCenter: parent.horizontalCenter
                    model: ["Test1", "Test2", "Test3"]
                }

                CustomSpinBox {
                    id: spinBox
                    anchors.horizontalCenter: parent.horizontalCenter
                    Component.onCompleted: {
                        spinBox.setFrom(0)
                        spinBox.setTo(1000)
                        spinBox.setValue(50)
                    }
                }
            }
        }
    }
}
