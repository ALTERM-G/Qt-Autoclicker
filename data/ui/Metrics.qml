pragma Singleton
import QtQuick

QtObject {
    // --- Window ---
    readonly property int windowWidth: 450
    readonly property int windowHeight: 600
    
    // --- Layout ---
    readonly property int appRectWidth: 400
    readonly property int appRectHeight: 420
    
    // --- Top Bar ---
    readonly property int topBarHeight: 75
    readonly property int dividerThickness: 2

    // --- Control sizing ---
    readonly property int controlHeight: 40
    readonly property int controlHeightCompact: 32
    readonly property int buttonWidth: 150
    readonly property int comboBoxWidth: 240
    readonly property int spinBoxWidth: 120
    readonly property int iconButtonSize: 40
    readonly property int iconButtonInnerSize: 20
    readonly property int iconSizeS: 17
    readonly property int iconSizeM: 24
    readonly property int iconSizeL: 30
    readonly property int iconSizeXL: 40

    // --- Spacing ---
    readonly property int spacingXS: 4
    readonly property int spacingS: 8
    readonly property int spacingM: 12
    readonly property int spacingL: 20
    readonly property int spacingXL: 60
    readonly property int spacingXXL: 100
    
    // --- Margins ---
    readonly property int marginXS: 2
    readonly property int marginS: 3
    readonly property int marginM: 10
    readonly property int marginL: 15
    readonly property int marginXL: 20

    // --- Borders ---
    readonly property int borderThin: 1
    readonly property int borderNormal: 2
    readonly property int borderThick: 3

    // --- Radius ---
    readonly property int radiusS: 3
    readonly property int radiusM: 5
    readonly property int radiusL: 8
}
