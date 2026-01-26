import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: root
    property string path: ""
    property color color: "black"

    width: Metrics.iconSizeM
    height: Metrics.iconSizeM

    Image {
        id: sourceImage
        anchors.fill: parent
        visible: false
        source: root.path
        fillMode: Image.PreserveAspectFit
        smooth: true
        sourceSize: Qt.size(root.width, root.height)
    }

    ColorOverlay {
        anchors.fill: parent
        source: sourceImage
        color: root.color
    }
}
