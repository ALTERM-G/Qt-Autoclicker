import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: settingsMenu
    width: Metrics.iconButtonSize
    height: Metrics.iconButtonSize
    property bool isPopupOpen: settingsPopup.opened
    onIsPopupOpenChanged: controller.set_shortcuts_enabled(!isPopupOpen)

    IconButton {
        id: settingsButton
        anchors.centerIn: parent
        iconPath: SVGLibrary.settings
        buttonWidth: Metrics.iconButtonSize
        buttonHeight: Metrics.iconButtonSize

        CustomToolTip {
            text: "Settings"
            visible: settingsButton.hovered
            delay: 600
        }

        onPressed: {
            settingsPopup.opened ? settingsPopup.close() : settingsPopup.open()
        }
    }

    CustomPopup {
        id: settingsPopup
        width: AppConfig.appRectWidth
        height: AppConfig.appRectHeight
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2

        background: AppRect {
            anchors.fill: parent

            IconButton {
                anchors.top: parent.top
                anchors.topMargin: Metrics.spacingL
                anchors.left: parent.left
                anchors.leftMargin: Metrics.spacingL
                iconPath: SVGLibrary.back
                onPressed: {settingsPopup.close()}
            }

            ColumnLayout {
                anchors.top: parent.top
                anchors.topMargin: Metrics.spacingL
                anchors.horizontalCenter: parent.horizontalCenter

                CustomText {
                    text: "Settings"
                    Layout.alignment: Qt.AlignHCenter
                }

                CustomText {
                    text: "Themes"
                    style_2: true
                    Layout.fillWidth: true
                    Layout.leftMargin: Metrics.marginXL
                    Layout.topMargin: Metrics.marginL
                }

                CustomComboBox {
                    id: themeComboBox
                    Layout.topMargin: Metrics.marginXS
                    Layout.preferredHeight: Metrics.controlHeight
                    model: ["Carbon Amber", "Catppuccin Mocha", "Dracula", "Everforest", "Monokai","Github Dark", "Gruvbox", "Vanilla Light"]
                    onCurrentTextChanged: {
                        if (initialized) {
                            Theme.setTheme(currentText)
                        }
                    }
                    Layout.fillWidth: true

                    property bool initialized: false

                    Connections {
                        target: settingsPopup
                        function onOpened() {
                            var currentThemeIndex = themeComboBox.model.indexOf(Theme.currentTheme)
                            if (currentThemeIndex !== -1) {
                                themeComboBox.initialized = false
                                themeComboBox.currentIndex = currentThemeIndex
                                themeComboBox.initialized = true
                            }
                        }
                    }
                }

                CustomText {
                    text: "Run Shortcut"
                    style_2: true
                    Layout.fillWidth: true
                    Layout.leftMargin: Metrics.marginXL
                    Layout.topMargin: Metrics.marginL
                }

                CustomShortcutEditor {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Metrics.marginXS
                    shortcutType: "run"
                    allowLonelyLetters: false
                }

                CustomText {
                    text: "Stop shortcut"
                    style_2: true
                    Layout.fillWidth: true
                    Layout.leftMargin: Metrics.marginXL
                    Layout.topMargin: Metrics.marginL
                }

                CustomShortcutEditor {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Metrics.marginXS
                    shortcutType: "stop"
                    allowLonelyLetters: false
                }
            }
        }
    }
}
