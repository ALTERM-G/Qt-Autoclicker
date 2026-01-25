import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: Metrics.comboBoxWidth
    height: Metrics.controlHeight
    radius: Metrics.radiusXL
    color: Theme.backgroundColor()
    border.color: Theme.borderColor()
    border.width: Metrics.borderNormal
    property int cps: 0
    visible: running
    property bool running: false
    property real totalClicks: 0
    property real lastTimestamp: 0
    property real displayCps: 0

    function reset() {
        totalClicks = 0
        lastTimestamp = Date.now()
        displayCps = 0
    }

    Timer {
        interval: 100
        repeat: true
        running: root.running

        onRunningChanged: {
            if (running) {
                root.reset()
            } else {
                totalClicks = 0
                displayCps = 0
            }
        }

        onTriggered: {
            const now = Date.now()
            const dt = (now - root.lastTimestamp) / 1000.0
            root.lastTimestamp = now
            console.log("CPS value:", root.cps, "Running:", root.running)
            totalClicks += root.cps * dt
            displayCps = root.cps
        }
    }

    CustomText {
        text: Math.floor(totalClicks)
        style_3: true
        anchors.centerIn: parent
    }
}
