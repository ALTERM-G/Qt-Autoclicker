import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 240
    height: 40
    radius: 8
    focus: true
    border.width: 3
    color: recording ? Data.themeColor : Data.backgroundColor
    border.color: Data.borderColor

    // == Public API ==
    property string shortcutText: "Loading..."
    property int shortcutKey: 0
    property int shortcutModifiers: 0

    signal shortcutChanged(int key, int modifiers)

    // == Internal ==
    property bool recording: false

// == Initialize from settings ==
    Component.onCompleted: {
        updateFromSettings()
    }

    Connections {
        target: Data
        function onSettingsLoaded() {
            updateFromSettings()
        }
    }

    function updateFromSettings() {
        if (Data.settings && Data.settings.shortcuts && Data.settings.shortcuts.run) {
            var settingsShortcut = Data.settings.shortcuts.run
            shortcutKey = settingsShortcut.key
            shortcutModifiers = settingsShortcut.modifiers

            var parts = []
            if (shortcutModifiers & Qt.ControlModifier) parts.push("Ctrl")
            if (shortcutModifiers & Qt.AltModifier) parts.push("Alt")
            if (shortcutModifiers & Qt.ShiftModifier) parts.push("Shift")
            if (shortcutModifiers & Qt.MetaModifier) parts.push("Meta")
            var keyName = keyToString(shortcutKey)
            if (keyName !== "") parts.push(keyName)
            shortcutText = parts.join(" + ")
        }
    }

    // == Display ==
    CustomText {
        anchors.centerIn: parent
        text: recording ? "Press keys..." : root.shortcutText
        color: "white"
        font.underline: false
    }

    // == Mouse ==
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.recording = true
            root.forceActiveFocus()
        }
    }

    // == Key name mapper ==
    function keyToString(key) {
        // Function keys
        if (key >= Qt.Key_F1 && key <= Qt.Key_F35)
            return "F" + (key - Qt.Key_F1 + 1)
        // Letters
        if (key >= Qt.Key_A && key <= Qt.Key_Z)
            return String.fromCharCode(key)
        // Numbers
        if (key >= Qt.Key_0 && key <= Qt.Key_9)
            return String.fromCharCode(key)
        switch (key) {
        case Qt.Key_Tab: return "Tab"
        case Qt.Key_Backspace: return "Backspace"
        case Qt.Key_Return:
        case Qt.Key_Enter: return "Enter"
        case Qt.Key_Escape: return "Esc"
        case Qt.Key_Delete: return "Delete"
        case Qt.Key_Space: return "Space"
        case Qt.Key_Left: return "Left"
        case Qt.Key_Right: return "Right"
        case Qt.Key_Up: return "Up"
        case Qt.Key_Down: return "Down"
        case Qt.Key_Home: return "Home"
        case Qt.Key_End: return "End"
        case Qt.Key_PageUp: return "PageUp"
        case Qt.Key_PageDown: return "PageDown"
        }
        return ""
    }

    // == Keyboard handling ==

    Keys.onPressed: function(event) {
        if (!recording)
            return
        if (event.key === Qt.Key_Control ||
            event.key === Qt.Key_Shift ||
            event.key === Qt.Key_Alt ||
            event.key === Qt.Key_Meta) {
            event.accepted = true
            return
        }

        let parts = []
        if (event.modifiers & Qt.ControlModifier) parts.push("Ctrl")
        if (event.modifiers & Qt.AltModifier) parts.push("Alt")
        if (event.modifiers & Qt.ShiftModifier) parts.push("Shift")
        if (event.modifiers & Qt.MetaModifier) parts.push("Meta")
        let keyName = keyToString(event.key)
        if (keyName === "") return
        parts.push(keyName)
        shortcutKey = event.key
        shortcutModifiers = event.modifiers
        shortcutText = parts.join(" + ")

        if (!Data.settings.shortcuts) Data.settings.shortcuts = {}
        Data.settings.shortcuts.run = {
            "key": shortcutKey,
            "modifiers": shortcutModifiers
        }
        controller.save_settings_from_qml(JSON.stringify(Data.settings))

        shortcutChanged(shortcutKey, shortcutModifiers)
        recording = false
        event.accepted = true
    }
}
