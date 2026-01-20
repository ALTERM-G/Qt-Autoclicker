pragma Singleton
import QtQuick
import QtQuick.Window
import QtQuick.Controls

QtObject {
    readonly property string fontRegular: "JetBrainsMono NL"
    readonly property string fontBold: "JetBrainsMono"
    readonly property color themeColor: "#E78C02"
    readonly property color appBackgroundColor: "#101010"
    readonly property color topBarColor: "#060606"
    readonly property color backgroundColor: "#181818"
    readonly property color hoverBackgroundColor: "#B4B4B4"
    readonly property color borderColor: "#2B2B2B"
    readonly property color textColor: "#B4B4B4"
    readonly property color hoverTextColor: "#2A2A2A"
    readonly property color dividerColor: "#333333"

    // -- Tab --
    property ListModel tabModel: ListModel {
        ListElement {
            name: "Mouse"
            icon: "../../assets/icons/mouse.svg"
            hoverIcon: "../../assets/icons/mouse_hover.svg"
        }
        ListElement {
            name: "Keyboard"
            icon: "../../assets/icons/keyboard.svg"
            hoverIcon: "../../assets/icons/keyboard_hover.svg"
        }
    }

    // -- Settings --
    property var settings: { "shortcuts": {} }
    signal settingsSaved()
    signal settingsLoaded()

    function loadSettings() {
        var file = Qt.resolvedUrl("Settings.json")
        var xhr = new XMLHttpRequest()
        xhr.open("GET", file)
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                if(xhr.status === 200 || xhr.status === 0) {
                    settings = JSON.parse(xhr.responseText)
                    if (!settings.shortcuts) settings.shortcuts = {}
                    settingsLoaded()
                } else {
                    console.warn("Failed to load Settings.json")
                }
            }
        }
        xhr.send()
    }

    function saveSettings() {
        var file = Qt.resolvedUrl("Settings.json")
        var xhr = new XMLHttpRequest()
        xhr.open("PUT", file)
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                if(xhr.status === 200 || xhr.status === 0) {
                    console.log("Settings saved successfully")
                    settingsSaved()
                } else {
                    console.warn("Failed to save Settings.json")
                }
            }
        }
        xhr.send(JSON.stringify(settings, null, 2))
    }
}
