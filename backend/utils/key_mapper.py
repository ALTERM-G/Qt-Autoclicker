from PySide6.QtCore import Qt
from pynput import keyboard
from evdev import ecodes


class KeyMapper:
    # -----------------------------
    # Qt → pynput mapping
    # -----------------------------
    QT_TO_PYNPUT = {
        Qt.Key_F1: keyboard.Key.f1,
        Qt.Key_F2: keyboard.Key.f2,
        Qt.Key_F3: keyboard.Key.f3,
        Qt.Key_F4: keyboard.Key.f4,
        Qt.Key_F5: keyboard.Key.f5,
        Qt.Key_F6: keyboard.Key.f6,
        Qt.Key_F7: keyboard.Key.f7,
        Qt.Key_F8: keyboard.Key.f8,
        Qt.Key_F9: keyboard.Key.f9,
        Qt.Key_F10: keyboard.Key.f10,
        Qt.Key_F11: keyboard.Key.f11,
        Qt.Key_F12: keyboard.Key.f12,

        Qt.Key_Escape: keyboard.Key.esc,
        Qt.Key_Return: keyboard.Key.enter,
        Qt.Key_Enter: keyboard.Key.enter,
        Qt.Key_Space: keyboard.Key.space,
        Qt.Key_Tab: keyboard.Key.tab,
        Qt.Key_Backspace: keyboard.Key.backspace,
        Qt.Key_Delete: keyboard.Key.delete,

        Qt.Key_Left: keyboard.Key.left,
        Qt.Key_Right: keyboard.Key.right,
        Qt.Key_Up: keyboard.Key.up,
        Qt.Key_Down: keyboard.Key.down,
        Qt.Key_Home: keyboard.Key.home,
        Qt.Key_End: keyboard.Key.end,
        Qt.Key_PageUp: keyboard.Key.page_up,
        Qt.Key_PageDown: keyboard.Key.page_down,
    }

    for _char in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
        QT_TO_PYNPUT[getattr(Qt, f"Key_{_char}")] = keyboard.KeyCode.from_char(
            _char.lower()
        )

    for _num in "0123456789":
        QT_TO_PYNPUT[getattr(Qt, f"Key_{_num}")] = keyboard.KeyCode.from_char(_num)

    # -----------------------------
    # Qt → evdev mapping
    # -----------------------------
    QT_TO_EVDEV = {
        Qt.Key_F1: ecodes.KEY_F1,
        Qt.Key_F2: ecodes.KEY_F2,
        Qt.Key_F3: ecodes.KEY_F3,
        Qt.Key_F4: ecodes.KEY_F4,
        Qt.Key_F5: ecodes.KEY_F5,
        Qt.Key_F6: ecodes.KEY_F6,
        Qt.Key_F7: ecodes.KEY_F7,
        Qt.Key_F8: ecodes.KEY_F8,
        Qt.Key_F9: ecodes.KEY_F9,
        Qt.Key_F10: ecodes.KEY_F10,
        Qt.Key_F11: ecodes.KEY_F11,
        Qt.Key_F12: ecodes.KEY_F12,

        Qt.Key_Escape: ecodes.KEY_ESC,
        Qt.Key_Return: ecodes.KEY_ENTER,
        Qt.Key_Enter: ecodes.KEY_ENTER,
        Qt.Key_Space: ecodes.KEY_SPACE,
        Qt.Key_Tab: ecodes.KEY_TAB,
        Qt.Key_Backspace: ecodes.KEY_BACKSPACE,
        Qt.Key_Delete: ecodes.KEY_DELETE,

        Qt.Key_Left: ecodes.KEY_LEFT,
        Qt.Key_Right: ecodes.KEY_RIGHT,
        Qt.Key_Up: ecodes.KEY_UP,
        Qt.Key_Down: ecodes.KEY_DOWN,
        Qt.Key_Home: ecodes.KEY_HOME,
        Qt.Key_End: ecodes.KEY_END,
        Qt.Key_PageUp: ecodes.KEY_PAGEUP,
        Qt.Key_PageDown: ecodes.KEY_PAGEDOWN,
    }

    for _char in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
        QT_TO_EVDEV[getattr(Qt, f"Key_{_char}")] = getattr(ecodes, f"KEY_{_char}")

    for _num in "0123456789":
        QT_TO_EVDEV[getattr(Qt, f"Key_{_num}")] = getattr(ecodes, f"KEY_{_num}")

    # -----------------------------
    # Public API
    # -----------------------------
    @classmethod
    def qt_to_pynput(cls, qt_key: int, qt_modifiers: int = 0):
        key = cls.QT_TO_PYNPUT.get(qt_key)
        if key is None:
            raise KeyError(f"Unsupported Qt key: {qt_key}")
        return key

    @classmethod
    def qt_to_evdev(cls, qt_key: int, qt_modifiers: int = 0):
        key = cls.QT_TO_EVDEV.get(qt_key)
        if key is None:
            raise KeyError(f"Unsupported Qt key: {qt_key}")
        return key

    # -----------------------------
    # Defaults (Qt-level only)
    # -----------------------------
    @staticmethod
    def default_start_key():
        return Qt.Key_F6

    @staticmethod
    def default_stop_key():
        return Qt.Key_Escape
