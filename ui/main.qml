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

    Component.onCompleted: {
        Data.loadSettings()
    }

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

            Settings {
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        AppRect {
            id: appRect
            anchors.centerIn: parent
            anchors.topMargin: 100
            width: 400
            height: 420

            Column {
                anchors.fill: parent
                anchors.topMargin: 60
                spacing: 10

                CustomComboBox {
                    id: pressButton_comboBox
                    anchors.horizontalCenter: parent.horizontalCenter
                    model: ["left", "right"]
                    onCurrentTextChanged: {
                        controller.set_button(currentText)
                    }
                    Component.onCompleted: {
                        controller.set_button(currentText)
                    }
                }

                CustomSpinBox {
                    id: cpsSpin
                    anchors.horizontalCenter: parent.horizontalCenter
                    Component.onCompleted: {
                        cpsSpin.setFrom(1)
                        cpsSpin.setTo(1000)
                        cpsSpin.setValue(50)
                        controller.set_cps(cpsSpin.value)
                    }
                    onValueChanged: {
                        controller.set_cps(value)
                    }
                }
            }
        }

        CustomTabBar {
            id: tabBar
            anchors.top: appRect.top
            anchors.topMargin: 10
            anchors.left: appRect.left
            anchors.leftMargin: 10
            model: Data.tabModel
        }

        Row {
            anchors.top: appRect.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            CustomButton {
                id: run_button
                buttonText: "(F6)"
                run: true
                iconSource: "../../assets/icons/run.svg"
                hoverIconSource: "../../assets/icons/run_hover.svg"
                onPressed: {
                    controller.start_clicking(pressButton_comboBox.currentText, cpsSpin.value)
                }
            }

            CustomButton {
                id: stop_button
                buttonText: "(ESC)"
                run: false
                iconSource: "../../assets/icons/stop.svg"
                hoverIconSource: "../../assets/icons/stop_hover.svg"
                onPressed: {
                    controller.stop_clicking()
                }
            }
        }
    }
}
