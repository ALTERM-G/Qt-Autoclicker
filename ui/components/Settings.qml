import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: settingsMenu
    width: Metrics.iconButtonSize
    height: Metrics.iconButtonSize
    property bool isPopupOpen: settingsPopup.opened
    onIsPopupOpenChanged: controller.set_shortcuts_enabled(!isPopupOpen)

    Rectangle {
        id: buttonRect
        width: Metrics.iconButtonSize
        height: Metrics.iconButtonSize
        color: "transparent"
        scale: mouseArea.containsMouse ? 1.05 : 1.0

        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                settingsPopup.opened ? settingsPopup.close() : settingsPopup.open()
            }
        }

        SVGObject {
            anchors.centerIn: parent
            path: SVGLibrary.settings
            width: Metrics.iconButtonSize
            height: Metrics.iconButtonSize
            color: mouseArea.containsMouse ? Theme.themeColor() : Theme.textColor()

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }

    Popup {
        id: settingsPopup
        width: AppConfig.appRectWidth
        height: AppConfig.appRectHeight
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
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    property: "scale"
                    from: 1
                    to: 0.85
                    duration: 200
                    easing.type: Easing.InQuad
                }
            }
        }

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
