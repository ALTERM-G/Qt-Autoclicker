import QtQuick
import QtQuick.Controls

Rectangle {
    id: background
    anchors.fill: parent
    color: Theme.appBackgroundColor
    default property alias content: contentItem.data

    Rectangle {
        id: topBar
        height: AppConfig.topBarHeight
        color: Theme.topBarColor
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            id: divider
            height: AppConfig.dividerThickness
            color: Theme.dividerColor
            width: parent.width
            anchors.bottom: parent.bottom
        }

        Text {
            id: title_ASCII
            color: Theme.themeColor
            anchors.left: topBar.left
            anchors.verticalCenter: topBar.verticalCenter
            anchors.leftMargin: Metrics.marginM
            height: topBar.height
            text: ASCIIart.text
            font.pointSize: 4
            font.family: Typography.fontRegular
            wrapMode: Text.NoWrap
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            id: contentItem
            anchors.fill: parent
        }
    }
}
