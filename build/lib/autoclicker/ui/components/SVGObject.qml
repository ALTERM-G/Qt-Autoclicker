import QtQuick
import QtQuick.VectorImage
import QtQuick.Effects

Item {
    id: root
    property string path: ""
    property color color: "black"

    width: Metrics.iconSizeM
    height: Metrics.iconSizeM

    VectorImage {
        id: svg
        anchors.fill: parent
        source: root.path
        fillMode: VectorImage.PreserveAspectFit
        preferredRendererType: VectorImage.CurveRenderer
        layer.enabled: true
        layer.smooth: true
        layer.effect: MultiEffect {
            brightness: 1.0
            colorization: 1.0
            colorizationColor: root.color
        }
    }
}
