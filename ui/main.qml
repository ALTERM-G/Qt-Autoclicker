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

    Shortcut {
        sequence: "Ctrl+Tab"
        onActivated: {
            tabBar.currentIndex = (tabBar.currentIndex + 1) % tabBar.model.count
        }
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
                id: mouseView
                anchors.fill: parent
                anchors.topMargin: 60
                spacing: 12
                visible: tabBar.currentIndex === 0

                Column {
                    spacing: 3
                    anchors.horizontalCenter: parent.horizontalCenter

                    CustomText {
                        text: "Mouse Button"
                        style_2: true
                    }

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
                }

                Column {
                    spacing: 3
                    anchors.horizontalCenter: parent.horizontalCenter

                    Row {
                        spacing: 3

                        Image {
                            source: "../assets/icons/chrono.svg"
                            sourceSize: Qt.size(17, 17)
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        CustomText {
                            text: "CPS"
                            style_2: true
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

            Column {
                id: keyboardView
                anchors.fill: parent
                anchors.topMargin: 60
                spacing: 12
                visible: tabBar.currentIndex === 1
                property var keyboardShortcut: ({ "key": Qt.Key_A, "modifiers": 0, "text": "A" })

                Column {
                    spacing: 3
                    anchors.horizontalCenter: parent.horizontalCenter

                    CustomText {
                        text: "Keyboard Key"
                        style_2: true
                    }

                    CustomShortcutEditor {
                        id: keyboardShortcutEditor
                        anchors.horizontalCenter: parent.horizontalCenter
                        manageSettings: false
                        allowModifiers: false
                        shortcutText: keyboardView.keyboardShortcut.text

                        onShortcutChanged: function(key, modifiers, shortcutAsText) {
                            keyboardView.keyboardShortcut = {
                                "key": key,
                                "modifiers": modifiers,
                                "text": shortcutAsText
                            }
                            controller.set_keyboard_char(shortcutAsText)
                        }

                        Component.onCompleted: {
                            controller.set_keyboard_char(keyboardView.keyboardShortcut.text)
                        }
                    }
                }

                Column {
                    spacing: 3
                    anchors.horizontalCenter: parent.horizontalCenter
                    Row {
                        spacing: 3
                        Image {
                            source: "../assets/icons/chrono.svg"
                            sourceSize: Qt.size(17, 17)
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }
                        CustomText {
                            text: "Keyboard CPS"
                            style_2: true
                        }
                    }

                    CustomSpinBox {
                        id: keyboardCpsSpin
                        anchors.horizontalCenter: parent.horizontalCenter
                        Component.onCompleted: {
                            keyboardCpsSpin.setFrom(1)
                            keyboardCpsSpin.setTo(1000)
                            keyboardCpsSpin.setValue(50)
                            controller.set_cps(keyboardCpsSpin.value)
                        }
                        onValueChanged: {
                            controller.set_cps(value)
                        }
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

            Component.onCompleted: controller.set_current_view("mouse")
            onCurrentIndexChanged: {
                if (currentIndex === 0) {
                    controller.set_current_view("mouse")
                } else if (currentIndex === 1) {
                    controller.set_current_view("keyboard")
                }
            }
        }

        Row {
            anchors.top: appRect.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            CustomButton {
                id: run_button
                buttonText: "Run"
                run: true
                iconSource: "../../assets/icons/run.svg"
                hoverIconSource: "../../assets/icons/run_hover.svg"
                onPressed: {
                    if (tabBar.currentIndex === 0) {
                        controller.start_clicking(
                            pressButton_comboBox.currentText,
                            cpsSpin.value,
                            null
                        )
                    } else if (tabBar.currentIndex === 1) {
                        controller.start_clicking(
                            null,
                            keyboardCpsSpin.value,
                            keyboardShortcutEditor.shortcutText
                        )
                    }
                }
            }

            CustomButton {
                id: stop_button
                buttonText: "Stop"
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
