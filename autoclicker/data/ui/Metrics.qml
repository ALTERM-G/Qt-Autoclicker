pragma Singleton
import QtQuick

QtObject {

    // --- Control sizing ---
    readonly property int controlHeight: 40
    readonly property int controlHeightCompact: 35
    readonly property int buttonWidth: 150
    readonly property int comboBoxWidth: 240
    readonly property int spinBoxWidth: 120
    readonly property int iconButtonSize: 40
    readonly property int iconSizeS: 17
    readonly property int iconSizeM: 24
    readonly property int iconSizeL: 30

    // --- Spacing ---
    readonly property int spacingXS: 4
    readonly property int spacingS: 8
    readonly property int spacingM: 12
    readonly property int spacingL: 20
    readonly property int spacingXL: 60

    // --- Margins ---
    readonly property int marginS: 3
    readonly property int marginM: 10
    readonly property int marginXL: 20

    // --- Borders ---
    readonly property int borderSmall: 1
    readonly property int borderNormal: 2
    readonly property int borderThick: 3

    // --- Radius ---
    readonly property int radiusS: 3
    readonly property int radiusM: 6
    readonly property int radiusXL: 12
}
