import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "components"

ApplicationWindow {
    id: window
    visible: true
    width: AppConfig.windowWidth
    height: AppConfig.windowHeight
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height
    title: "Autoclicker"

    Component.onCompleted: {
        SettingsManager.loadSettings()
    }

    Shortcut {
        sequence: "Ctrl+Tab"
        enabled: !settings.isPopupOpen && !controller.is_running
        onActivated: {
            tabBar.currentIndex = (tabBar.currentIndex + 1) % SettingsManager.tabs.length
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Theme.appBackgroundColor

        Rectangle {
            id: topBar
            height: AppConfig.topBarHeight
            color: Theme.topBarColor
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            Rectangle {
                id: divider
                height: AppConfig.dividerThickness
                color: Theme.dividerColor
                width: parent.width
                anchors.bottom: parent.bottom
            }

            Text {
                id: title_ASCII
                color: Theme.themeColor
                anchors.left: topBar.left
                anchors.verticalCenter: topBar.verticalCenter
                anchors.leftMargin: Metrics.marginM
                height: topBar.height
                text: ASCIIart.text
                font.pointSize: 4
                font.family: Typography.fontRegular
                wrapMode: Text.NoWrap
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            Settings {
                id: settings
                anchors.right: parent.right
                anchors.rightMargin: Metrics.marginXL
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        AppRect {
            id: appRect
            anchors.centerIn: parent
            width: AppConfig.appRectWidth
            height: AppConfig.appRectHeight

            Column {
                id: mouseView
                anchors.fill: parent
                anchors.topMargin: Metrics.spacingXL
                spacing: Metrics.spacingM
                visible: tabBar.currentIndex === 0

                Column {
                    spacing: Metrics.spacingXS
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
                    spacing: Metrics.spacingXS
                    anchors.horizontalCenter: parent.horizontalCenter

                    Row {
                        spacing: Metrics.spacingXS

                        SVGObject {
                            path: SVGLibrary.chrono
                            width: Metrics.iconSizeS
                            height: Metrics.iconSizeS
                            color: Theme.borderColor
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
                anchors.topMargin: Metrics.spacingXL
                spacing: Metrics.spacingM
                visible: tabBar.currentIndex === 1
                property var keyboardShortcut: ({ "key": Qt.Key_A, "modifiers": 0, "text": "A" })

                Column {
                    spacing: Metrics.spacingXS
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
                    spacing: Metrics.spacingXS
                    anchors.horizontalCenter: parent.horizontalCenter
                    Row {
                        spacing: Metrics.spacingXS

                        SVGObject {
                            path: SVGLibrary.chrono
                            width: Metrics.iconSizeS
                            height: Metrics.iconSizeS
                            color: Theme.borderColor
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
            tabData: SettingsManager.tabs

            Component.onCompleted: controller.set_current_view("mouse")
            onCurrentIndexChanged: {
                if (currentIndex === 0) {
                    controller.set_current_view("mouse")
                } else if (currentIndex === 1) {
                    controller.set_current_view("keyboard")
                }
            }
        }

        CustomButton {
            id: run_button
            buttonText: "Run"
            run: true
            visible: !controller.is_running
            iconPath: SVGLibrary.run
            anchors.top: appRect.bottom
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
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

        Rectangle {
            id: overlay
            anchors.fill: parent
            color: "#80000000"
            visible: controller.is_running

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                hoverEnabled: true
                onPressed: {}
            }
        }

        CpsIndicator {
            id: cpsWidget
            cps: controller.cps
            running: controller.is_running
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: appRect.bottom
            anchors.bottomMargin: Metrics.marginM
        }

        CustomButton {
            id: stop_button
            buttonText: "Stop"
            visible: controller.is_running
            run: false
            iconPath: SVGLibrary.stop
            anchors.top: appRect.bottom
            anchors.topMargin: Metrics.marginXL
            anchors.horizontalCenter: parent.horizontalCenter
            onPressed: {
                controller.stop_clicking()
            }
        }
    }
}
