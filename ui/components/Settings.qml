import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: settingsMenu
    width: 40
    height: 40

    property bool isPopupOpen: settingsPopup.opened
    onIsPopupOpenChanged: controller.set_shortcuts_enabled(!isPopupOpen)


    Rectangle {
        id: buttonRect
        width: 40
        height: 40
        color: "transparent"
        scale: mouseArea.containsMouse ? 1.1 : 1.0

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
            width: 40
            height: 40
            color: mouseArea.containsMouse ? Theme.themeColor() : Theme.textColor()

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
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

            IconButton {
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                iconPath: SVGLibrary.back
                width: 30
                height: 30
                onPressed: {settingsPopup.close()}
            }

            ColumnLayout {
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter

                CustomText {
                    text: "Settings"
                    Layout.alignment: Qt.AlignHCenter
                }

                CustomText {
                    text: "Themes"
                    style_2: true
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    Layout.topMargin: 15
                }

                CustomComboBox {
                    id: themeComboBox
                    Layout.topMargin: 2
                    Layout.preferredHeight: 40
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
                                // Set initialized to false temporarily to prevent triggering setTheme
                                themeComboBox.initialized = false
                                themeComboBox.currentIndex = currentThemeIndex
                                // Now enable theme changes
                                themeComboBox.initialized = true
                            }
                        }
                    }
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
                    allowLonelyLetters: false
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
                    allowLonelyLetters: false
                }
            }
        }
    }
}
