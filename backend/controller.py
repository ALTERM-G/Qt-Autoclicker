from PySide6.QtCore import QObject, QThread, Signal, Slot
from PySide6.QtGui import QGuiApplication
from pynput import keyboard
from evdev import ecodes
from pathlib import Path
import json

from backend.Workers.MouseClicking import PynputClickWorker, WaylandClickWorker
from backend.Workers.KeyboardClicking import PynputKeyboardWorker, WaylandKeyboardWorker
from backend.Workers.ShortcutHandling import ShortcutWorker, WaylandShortcutWorker
from backend.utils import KeyMapper, is_wayland


class Controller(QObject):
    status_update = Signal(str)

    def __init__(self):
        super().__init__()
        self._mouse_worker = None
        self._mouse_thread = None
        self._keyboard_worker = None
        self._keyboard_thread = None
        self._shortcut_thread = None
        self._shortcut_worker = None
        self._button = "left"
        self._keyboard_char = "a"
        self._cps = 50
        self._settings_path = Path(__file__).parent.parent / "data" / "Settings.json"
        self._settings_last_modified = 0
        self._setup_shortcuts()

    def _load_settings(self):
        try:
            if self._settings_path.exists():
                current_mtime = self._settings_path.stat().st_mtime
                if current_mtime > self._settings_last_modified:
                    with open(self._settings_path) as f:
                        settings = json.load(f)
                        self._settings_last_modified = current_mtime
                        return settings
        except Exception as e:
            print(f"Error loading settings: {e}")

        return {
            "shortcuts": {
                "run": {"key": KeyMapper.default_start_key(), "modifiers": 0},
                "stop": {"key": KeyMapper.default_stop_key(), "modifiers": 0},
            }
        }

    def _setup_shortcuts(self):
        settings = self._load_settings()
        run_key = settings["shortcuts"]["run"]["key"]
        run_modifiers = settings["shortcuts"]["run"]["modifiers"]
        stop_qt_key = settings["shortcuts"]["stop"]["key"]
        stop_modifiers = settings["shortcuts"]["stop"]["modifiers"]

        if not is_wayland():
            start_key = KeyMapper.qt_to_pynput(run_key, run_modifiers)
            stop_key = KeyMapper.qt_to_pynput(stop_qt_key, stop_modifiers)

            self._shortcut_worker = ShortcutWorker(
                start_key=start_key,
                stop_key=stop_key,
            )
        else:
            start_key = KeyMapper.qt_to_evdev(run_key, run_modifiers)
            stop_key = KeyMapper.qt_to_evdev(stop_qt_key, stop_modifiers)

            self._shortcut_worker = WaylandShortcutWorker(
                start_key=start_key,
                stop_key=stop_key,
            )

        self._shortcut_thread = QThread()
        self._shortcut_worker.moveToThread(self._shortcut_thread)
        self._shortcut_thread.started.connect(self._shortcut_worker.start_listening)
        self._shortcut_worker.start_signal.connect(self.start_clicking_shortcut)
        self._shortcut_worker.stop_signal.connect(self.stop_clicking)
        self._shortcut_thread.start()

    @Slot()
    def reload_shortcuts(self):
        if self._shortcut_worker:
            self._shortcut_worker.stop_listening()
        if self._shortcut_thread and self._shortcut_thread.isRunning():
            self._shortcut_thread.quit()
            self._shortcut_thread.wait()
        self._setup_shortcuts()

    @Slot()
    def save_settings(self):
        try:
            import json

            if self._settings_path.exists():
                with open(self._settings_path, "r") as f:
                    settings = json.load(f)
            else:
                settings = {}
            from pathlib import Path

            self.reload_shortcuts()
        except Exception as e:
            print(f"Error saving settings: {e}")

    @Slot(str)
    def save_settings_from_qml(self, settings_json):
        try:
            import json

            settings = json.loads(settings_json)
            with open(self._settings_path, "w") as f:
                json.dump(settings, f, indent=2)

            print(f"Settings saved to {self._settings_path}")
            self.reload_shortcuts()

        except Exception as e:
            print(f"Error saving settings: {e}")

    @Slot(str)
    def set_button(self, button):
        self._button = button

    @Slot(int)
    def set_cps(self, cps):
        self._cps = cps

    @Slot()
    def start_clicking_shortcut(self):
        self.start_clicking(self._button, self._cps)

    @Slot(str, int)
    def start_clicking(self, button, cps, keyboard_text=None):
        interval = 1.0 / cps
        screen = QGuiApplication.primaryScreen()
        geometry = screen.geometry()
        center_x = geometry.width() // 2
        center_y = geometry.height() // 2

        # ---------------- Mouse Worker ----------------
        if is_wayland():
            self._mouse_worker = WaylandClickWorker(
                button=button, interval=interval, x=center_x, y=center_y
            )
        else:
            self._mouse_worker = PynputClickWorker(button=button, interval=interval)

        self._mouse_thread = QThread()
        self._mouse_worker.moveToThread(self._mouse_thread)
        self._mouse_thread.started.connect(self._mouse_worker.start_clicking)
        self._mouse_worker.finished.connect(self._cleanup_mouse)
        self._mouse_worker.status.connect(self.status_update)
        self._mouse_thread.start()

        # ---------------- Keyboard Worker ----------------
        if keyboard_text:
            self._keyboard_text = keyboard_text
            if is_wayland():
                self._keyboard_worker = WaylandKeyboardWorker(
                    text=self._keyboard_text, interval=interval
                )
            else:
                self._keyboard_worker = PynputKeyboardWorker(
                    text=self._keyboard_text, interval=interval
                )

            self._keyboard_thread = QThread()
            self._keyboard_worker.moveToThread(self._keyboard_thread)
            self._keyboard_thread.started.connect(self._keyboard_worker.start_typing)
            self._keyboard_worker.finished.connect(self._cleanup_keyboard)
            self._keyboard_worker.status.connect(self.status_update)
            self._keyboard_thread.start()

    @Slot()
    def stop_clicking(self):
        if self._mouse_worker:
            self._mouse_worker.stop_clicking()
            if self._keyboard_worker:
                self._keyboard_worker.stop_typing()

    def _cleanup_mouse(self):
        if self._mouse_thread:
            self._mouse_thread.quit()
            self._mouse_thread.wait()
            if self._mouse_worker:
                self._mouse_worker.deleteLater()
                if self._mouse_thread:
                    self._mouse_thread.deleteLater()
                    self._mouse_worker = None
                    self._mouse_thread = None

    def _cleanup_keyboard(self):
        if self._keyboard_thread:
            self._keyboard_thread.quit()
            self._keyboard_thread.wait()
            if self._keyboard_worker:
                self._keyboard_worker.deleteLater()
                if self._keyboard_thread:
                    self._keyboard_thread.deleteLater()
                    self._keyboard_worker = None
                    self._keyboard_thread = None

    def cleanup_shortcuts(self):
        try:
            if self._shortcut_worker:
                self._shortcut_worker.stop_listening()
                if self._shortcut_thread and self._shortcut_thread.isRunning():
                    self._shortcut_thread.quit()
                    self._shortcut_thread.wait()
        except RuntimeError:
            pass

    def __del__(self):
        try:
            self.cleanup_shortcuts()
        except:
            pass
