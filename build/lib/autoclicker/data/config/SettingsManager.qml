pragma Singleton
import QtQuick
import QtQuick.Window
import QtQuick.Controls

QtObject {
    // -- Tab --
    property var tabs: [
        { name: "Mouse", icon: SVGLibrary.mouse },
        { name: "Keyboard", icon: SVGLibrary.keyboard }
    ]

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
