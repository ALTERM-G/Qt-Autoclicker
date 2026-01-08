import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Item {
    id: root
    width: 196
    height: 280

    property string selectedButton: ""
    property real buttonHeight: height * 0.4
    property real borderWidth: 4
    property real cornerRadius: width / 2
    property real highlightInset: root.borderWidth - 1
    property color highlightColor: "#E78C02"
    property color transparentColor: "transparent"
    property color middleButtonDefaultColor: "#101010"
    property color leftButtonColor: root.transparentColor
    property color rightButtonColor: root.transparentColor
    property color middleButtonColor: root.middleButtonDefaultColor

    Behavior on leftButtonColor {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on rightButtonColor {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on middleButtonColor {
        ColorAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    function selectButton(buttonName) {
        if (root.selectedButton === buttonName) {
            // Deselect
            root.selectedButton = "";
        } else {
            // Select
            root.selectedButton = buttonName;
        }

        root.leftButtonColor = (root.selectedButton === "left" ? root.highlightColor : root.transparentColor);
        root.rightButtonColor = (root.selectedButton === "right" ? root.highlightColor : root.transparentColor);
        root.middleButtonColor = (root.selectedButton === "middle" ? root.highlightColor : root.middleButtonDefaultColor);
    }

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
            antialiasing: true

            ShapePath {
                id: leftButtonShapePath
                fillColor: root.leftButtonColor
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
            antialiasing: true

            ShapePath {
                id: rightButtonShapePath
                fillColor: root.rightButtonColor
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
                if (mousePoint.y < 0 || mousePoint.y >= root.buttonHeight) {
                    containsMouse = false;
                    return;
                }

                if (mousePoint.y >= root.cornerRadius) {
                    containsMouse = true;
                    return;
                }

                var isInside = false;
                if (mousePoint.x < root.width / 2) {
                    var dist = Math.sqrt(Math.pow(mousePoint.x - root.cornerRadius, 2) + Math.pow(mousePoint.y - root.cornerRadius, 2));
                    if (dist < root.cornerRadius) {
                        isInside = true;
                    }
                } else {
                    var dist = Math.sqrt(Math.pow(mousePoint.x - (root.width - root.cornerRadius), 2) + Math.pow(mousePoint.y - root.cornerRadius, 2));
                    if (dist < root.cornerRadius) {
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
                    root.selectButton(mouse.x < root.width / 2 ? "left" : "right");
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
            color: root.middleButtonColor
            border.color: "#ffffff"
            border.width: root.borderWidth
            anchors.top: parent.top
            anchors.topMargin: 48
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed: root.selectButton("middle")
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
