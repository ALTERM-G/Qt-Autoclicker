import QtQuick
import QtQuick.Controls

Text {
    id: text
    property bool style_2: false
    property bool style_3: false
    property int pointSize: Typography.normalFontSize
    property color textColor: style_2 ? Theme.borderColor : style_3 ? Theme.themeColor : Theme.themeColor

    font.pointSize: style_2 ? Typography.smallFontSize : pointSize
    font.family: Typography.fontBold
    font.underline: style_3 ? false : style_2 ? false : true
    color: textColor
}
