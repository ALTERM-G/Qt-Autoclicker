import QtQuick
import QtQuick.Controls

ToolTip {
    id: customToolTip

    background: Rectangle {
        radius: Metrics.radiusM
        color: Theme.backgroundColor
        border.color: Theme.borderColor
        border.width: Metrics.borderSmall
    }

    contentItem: Text {
        text: customToolTip.text
        color: Theme.textColor
        font.family: Typography.fontBold
        font.pointSize: 10
        padding: Metrics.spacingXS
    }

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
}
