import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Item {
    id: root
    width: 196
    height: 280

    property string selectedButton: ""
    property real buttonHeight: height * 0.4
    property real borderWidth: 8
    property real cornerRadius: width / 2
    property real highlightInset: root.borderWidth - 1

    Rectangle {
        id: body
        anchors.fill: parent
        radius: root.cornerRadius
        color: "transparent"
        clip: true
        antialiasing: true

        /* ===== Left button highlight ===== */
        Shape {
            id: leftButtonHighlight
            width: parent.width / 2
            height: root.buttonHeight
            visible: root.selectedButton === "left"
            antialiasing: true

            ShapePath {
                fillColor: "#E78C02"
                strokeWidth: 0
                PathSvg {
                    path: "M " + (root.width / 2 - root.borderWidth / 2) + " " + root.buttonHeight +
                          " L " + root.highlightInset + " " + root.buttonHeight +
                          " L " + root.highlightInset + " " + root.cornerRadius +
                          " A " + (root.cornerRadius - root.highlightInset) + " " +
                          (root.cornerRadius - root.highlightInset) + " 0 0 1 " + root.cornerRadius +
                          " " + root.highlightInset + " L " + (root.width / 2 - root.borderWidth / 2) +
                          " " + root.highlightInset +
                          " Z"
                }
            }
        }

        /* ===== Right button highlight ===== */
        Shape {
            id: rightButtonHighlight
            x: parent.width / 2
            width: parent.width / 2
            height: root.buttonHeight
            visible: root.selectedButton === "right"
            antialiasing: true

            ShapePath {
                fillColor: "#E78C02"
                strokeWidth: 0
                PathSvg {
                    path: "M " + (root.borderWidth/2) + " " + root.buttonHeight +
                          " L " + (root.width/2 - root.highlightInset) + " " + root.buttonHeight +
                          " L " + (root.width/2 - root.highlightInset) + " " + root.cornerRadius +
                          " A " + (root.cornerRadius - root.highlightInset) + " " + (root.cornerRadius - root.highlightInset) + " 0 0 0 " + 0 + " " + root.highlightInset +
                          " L " + (root.borderWidth/2) + " " + root.highlightInset +
                          " Z"
                }
            }
        }

        /* ===== Left and Right Button MouseArea ===== */
        MouseArea {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            height: root.buttonHeight
            hoverEnabled: true

            property bool containsMouse: false

            cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor

            function updateContainsMouse(mousePoint) {
                var isInside = false;
                if (mousePoint.y >= 0 && mousePoint.y < root.buttonHeight) {
                    if (mousePoint.y < root.cornerRadius) {
                        var dist = Math.sqrt(Math.pow(mousePoint.x - root.cornerRadius, 2) + Math.pow(mousePoint.y - root.cornerRadius, 2));
                        if (dist < root.cornerRadius) {
                            isInside = true;
                        }
                    } else {
                        isInside = true;
                    }
                }
                containsMouse = isInside;
            }

            onPositionChanged: function(mouse) { updateContainsMouse(mouse) }
            onEntered: function() { updateContainsMouse({ x: mouseX, y: mouseY }) }
            onExited: containsMouse = false

            onPressed: function(mouse) {
                if (containsMouse) {
                    var clickedButton = mouse.x < root.width / 2 ? "left" : "right";
                    if (root.selectedButton === clickedButton) {
                        root.selectedButton = "";
                    } else {
                        root.selectedButton = clickedButton;
                    }
                }
            }
        }

        /* ===== Vertical divider ===== */
        Rectangle {
            width: root.borderWidth
            height: root.buttonHeight
            color: "#ffffff"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        /* ===== Horizontal divider ===== */
        Rectangle {
            height: root.borderWidth
            width: parent.width
            color: "#ffffff"
            y: root.buttonHeight
        }

        /* ===== Wheel button ===== */
        Rectangle {
            width: 28
            height: 56
            radius: 14
            color: root.selectedButton === "middle" ? "#E78C02" : "#101010"
            border.color: "#ffffff"
            border.width: root.borderWidth
            anchors.top: parent.top
            anchors.topMargin: 48
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed: {
                    if (root.selectedButton === "middle") {
                        root.selectedButton = "";
                    } else {
                        root.selectedButton = "middle";
                    }
                }
            }
        }

        /* ===== Border on top ===== */
        Rectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            color: "transparent"
            border.color: "#ffffff"
            border.width: root.borderWidth
            antialiasing: true
        }
    }
}
