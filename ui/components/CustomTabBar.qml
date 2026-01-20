import QtQuick

Rectangle {
    id: root
    color: Data.backgroundColor
    implicitHeight: 30
    implicitWidth: 220
    border.color: Data.borderColor
    border.width: 2
    radius: 5

    property alias model: listView.model
    property alias currentIndex: listView.currentIndex

    ListView {
        id: listView
        anchors.fill: parent
        spacing: 1
        anchors.margins: 1
        currentIndex: 0
        interactive: false
        orientation: Qt.Horizontal
        highlightFollowsCurrentItem: false

        delegate: Item {
            id: listDelegate
            width: listView.width / listView.model.count
            height: listView.height

            Row {
                spacing: 5
                anchors.centerIn: parent

                Image {
                    id: tabIcon
                    source: listView.currentIndex === index ? model.hoverIcon : model.icon
                    sourceSize: Qt.size(17, 17)
                    fillMode: Image.PreserveAspectFit
                    opacity: listView.currentIndex === index ? 1 : 0.6

                    Behavior on opacity {
                        NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                    }
                }

                CustomText {
                    id: tabText
                    text: model.name
                    color: listView.currentIndex === index ? Data.borderColor : Data.textColor
                    font.underline: false
                    pointSize: 11
                    font.bold: listView.currentIndex === index

                    Behavior on color {
                        ColorAnimation { duration: 150; easing.type: Easing.InOutQuad }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: listView.currentIndex = index
                cursorShape: Qt.PointingHandCursor
            }
        }

        highlight: Item {
            width: listView.currentItem.width
            height: listView.currentItem.height
            x: listView.currentItem.x

            Behavior on x {
                NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                color: Data.themeColor
                radius: 5
            }
        }
    }
}
