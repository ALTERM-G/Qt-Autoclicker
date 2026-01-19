import QtQuick
import QtQuick.Controls

Text {
    id: text
    property bool style_2: false

    font.pointSize: style_2 ? 11 : 14
    font.family: Data.fontBold
    font.underline: style_2 ? false : true
    color: style_2 ? Data.borderColor : Data.themeColor
}
