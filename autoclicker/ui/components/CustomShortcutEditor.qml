import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: Metrics.comboBoxWidth
    height: Metrics.controlHeight
    radius: Metrics.radiusM
    focus: true
    border.width: Metrics.borderThick
    color: recording ? Theme.themeColor : Theme.backgroundColor
    border.color: Theme.borderColor

    // == Public API ==
    property bool allowLonelyLetters: true
    property bool manageSettings: true
    property bool allowModifiers: true
    property string shortcutText: manageSettings ? "Loading..." : "Set Shortcut"
    property int shortcutKey: 0
    property int shortcutModifiers: 0
    property string shortcutType: "run"

    signal shortcutChanged(int key, int modifiers, string shortcutAsText)

    // == Internal ==
    property bool recording: false

    // == Initialize from settings ==
    Component.onCompleted: {
        if (manageSettings) {
            updateFromSettings()
        }
    }

    Connections {
        target: SettingsManager
        function onSettingsLoaded() {
            if (manageSettings) {
                updateFromSettings()
            }
        }
    }

    function updateFromSettings() {
        if (SettingsManager.settings && SettingsManager.settings.shortcuts && SettingsManager.settings.shortcuts[shortcutType]) {
            var settingsShortcut = SettingsManager.settings.shortcuts[shortcutType]
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
            shortcutChanged(shortcutKey, shortcutModifiers, shortcutText)
        }
    }

    // == Display ==
    CustomText {
        anchors.centerIn: parent
        text: recording ? "Press keys..." : root.shortcutText
        color: Theme.textColor
        font.underline: false
    }

    // == Mouse ==
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.recording = true
            root.forceActiveFocus
        }
    }

    // == Key name mapper ==
    function keyToString(key) {
        // Function keys
        if (key >= Qt.Key_F1 && key <= Qt.Key_F35)
            return "F" + (key - Qt.Key_F1 + 1)
        // Letters
        if (key >= Qt.Key_A && key <= Qt.Key_Z)
            return String.fromCharCode(key).toUpperCase()
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

    function isShortcutTaken(key, modifiers) {
        if (!SettingsManager.settings || !SettingsManager.settings.shortcuts) {
            return false
        }

        for (var type in SettingsManager.settings.shortcuts) {
            if (type === shortcutType) {
                continue
            }
            var shortcut = SettingsManager.settings.shortcuts[type]
            if (shortcut.key === key && shortcut.modifiers === modifiers) {
                return true
            }
        }
        return false
    }

    // == Keyboard handling ==
    Keys.onPressed: function(event) {
        if (!recording)
            return

        if (event.key === Qt.Key_Escape) {
            recording = false
            event.accepted = true
            return
        }

        if (event.key === Qt.Key_Control ||
            event.key === Qt.Key_Shift ||
            event.key === Qt.Key_Alt ||
            event.key === Qt.Key_Meta) {
            event.accepted = true
            return
        }

        if (!allowLonelyLetters) {
            var isLetter = (event.key >= Qt.Key_A && event.key <= Qt.Key_Z)
            if (isLetter && (event.modifiers === 0)) {
                console.log("Single letter shortcuts are not allowed here.")
                return
            }
        }

        let keyName = keyToString(event.key)
        if (keyName === "") return

        var currentKey = event.key
        var currentModifiers = event.modifiers

        if (!allowModifiers) {
            if (currentModifiers & (Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier)) {
                return;
            }
            currentModifiers = 0;
        }

        if (isShortcutTaken(currentKey, currentModifiers)) {
            var originalText = shortcutText
            shortcutText = "Already taken!"
            var timer = Qt.createQmlObject("import QtQuick; Timer {}", root)
            timer.interval = 1500
            timer.repeat = false
            timer.triggered.connect(function() {
                shortcutText = originalText
                timer.destroy()
            })
            timer.start()
            recording = false
            return
        }

        shortcutKey = currentKey
        shortcutModifiers = currentModifiers

        var parts = []
        if (currentModifiers & Qt.ControlModifier) parts.push("Ctrl")
        if (currentModifiers & Qt.AltModifier) parts.push("Alt")
        if (currentModifiers & Qt.ShiftModifier) parts.push("Shift")
        if (currentModifiers & Qt.MetaModifier) parts.push("Meta")

        parts.push(keyName)
        shortcutText = parts.join(" + ")


        if (manageSettings) {
            if (!SettingsManager.settings.shortcuts) SettingsManager.settings.shortcuts = {}
                SettingsManager.settings.shortcuts[shortcutType] = {
                "key": shortcutKey,
                "modifiers": shortcutModifiers
            }
            controller.save_settings_from_qml(JSON.stringify(SettingsManager.settings))
        }

        shortcutChanged(shortcutKey, shortcutModifiers, shortcutText)
        recording = false
        event.accepted = true
    }
}
