pragma Singleton
import QtQuick
import QtQuick.Controls

QtObject {
    // --- Fonts ---
    readonly property string fontRegular: "JetBrainsMono NL"
    readonly property string fontBold: "JetBrainsMono"

    // --- Current Theme ---
    property string currentTheme: "Carbon Amber"

    // --- Theme colors ---
    readonly property var themes: {
        "Catppuccin Mocha": {
            themeColor: "#F5C2E7", appBackgroundColor: "#1E1E2E", topBarColor: "#181825",
            backgroundColor: "#1E1E2E", hoverBackgroundColor: "#F2CDCD", borderColor: "#313244",
            textColor: "#C6D0F5", hoverTextColor: "#1E1E2E", dividerColor: "#313244"
        },
        "Dracula": {
            themeColor: "#BD93F9", appBackgroundColor: "#282A36", topBarColor: "#21222C",
            backgroundColor: "#282A36", hoverBackgroundColor: "#6272A4", borderColor: "#44475A",
            textColor: "#F8F8F2", hoverTextColor: "#282A36", dividerColor: "#44475A"
        },
        "Everforest": {
            themeColor: "#8DA101", appBackgroundColor: "#2B3339", topBarColor: "#232B2F",
            backgroundColor: "#2B3339", hoverBackgroundColor: "#A7C080", borderColor: "#3B4349",
            textColor: "#D3C6AA", hoverTextColor: "#2B3339", dividerColor: "#3B4349"
        },
        "Monokai": {
            themeColor: "#A6E22E", appBackgroundColor: "#272822", topBarColor: "#1E1C1C",
            backgroundColor: "#272822", hoverBackgroundColor: "#F92672", borderColor: "#3A3A3A",
            textColor: "#F8F8F2", hoverTextColor: "#272822", dividerColor: "#3A3A3A"
        },
        "Gruvbox": {
            themeColor: "#FB4934", appBackgroundColor: "#282828", topBarColor: "#1D2021",
            backgroundColor: "#282828", hoverBackgroundColor: "#FABD2F", borderColor: "#3C3836",
            textColor: "#EBDBB2", hoverTextColor: "#282828", dividerColor: "#3C3836"
        },
        "Vanilla Light": {
            themeColor: "#E78C02", appBackgroundColor: "#FDF6E3", topBarColor: "#F5EDE0",
            backgroundColor: "#FFFFFF", hoverBackgroundColor: "#E6D7B9", borderColor: "#D6C8AD",
            textColor: "#2A2A2A", hoverTextColor: "#FFFFFF", dividerColor: "#CFCFCF"
        },
        "Carbon Amber": {
            themeColor: "#E78C02", appBackgroundColor: "#101010", topBarColor: "#060606",
            backgroundColor: "#181818", hoverBackgroundColor: "#B4B4B4", borderColor: "#2B2B2B",
            textColor: "#B4B4B4", hoverTextColor: "#2A2A2A", dividerColor: "#333333"
        }
    }

    // --- Accessor functions for current theme ---
    function themeColor() { return themes[currentTheme].themeColor }
    function appBackgroundColor() { return themes[currentTheme].appBackgroundColor }
    function topBarColor() { return themes[currentTheme].topBarColor }
    function backgroundColor() { return themes[currentTheme].backgroundColor }
    function hoverBackgroundColor() { return themes[currentTheme].hoverBackgroundColor }
    function borderColor() { return themes[currentTheme].borderColor }
    function textColor() { return themes[currentTheme].textColor }
    function hoverTextColor() { return themes[currentTheme].hoverTextColor }
    function dividerColor() { return themes[currentTheme].dividerColor }

    // --- Method to change theme ---
    function setTheme(name) {
        if (themes[name]) {
            currentTheme = name
        } else {
            console.warn("Theme not found: " + name)
        }
    }
}
