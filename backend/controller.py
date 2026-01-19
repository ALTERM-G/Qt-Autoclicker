from PySide6.QtCore import QObject, QThread, Signal, Slot
from PySide6.QtGui import QGuiApplication
from pynput import keyboard
from evdev import ecodes
from pathlib import Path
import json

from backend.Workers.pynput_worker import PynputClickWorker
from backend.Workers.wayland_worker import WaylandClickWorker
from backend.Workers.shortcut_worker import ShortcutWorker
from backend.Workers.wayland_shortcut_worker import WaylandShortcutWorker
from backend.utils.platform import is_wayland
from backend.utils.key_mapper import KeyMapper


class Controller(QObject):
    status_update = Signal(str)

    def __init__(self):
        super().__init__()
        self._thread = None
        self._worker = None
        self._shortcut_thread = None
        self._shortcut_worker = None
        self._button = "left"
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
    def start_clicking(self, button, cps):
        if self._thread and self._thread.isRunning():
            self.status_update.emit("Already clicking")
            return

        interval = 1.0 / cps
        screen = QGuiApplication.primaryScreen()
        geometry = screen.geometry()
        center_x = geometry.width() // 2
        center_y = geometry.height() // 2

        if is_wayland():
            self.status_update.emit("Wayland mode: clicking screen center")
            self._worker = WaylandClickWorker(
                button=button,
                interval=interval,
                x=center_x,
                y=center_y,
            )
        else:
            self._worker = PynputClickWorker(button, interval)

        self._thread = QThread()
        self._worker.moveToThread(self._thread)

        self._thread.started.connect(self._worker.start_clicking)
        self._worker.finished.connect(self._cleanup)
        self._worker.status.connect(self.status_update)

        self._thread.start()

    @Slot()
    def stop_clicking(self):
        if self._worker:
            self._worker.stop_clicking()

    def _cleanup(self):
        if self._thread:
            self._thread.quit()
            self._thread.wait()
        if self._worker:
            self._worker.deleteLater()
        if self._thread:
            self._thread.deleteLater()
        self._worker = None
        self._thread = None
        self.status_update.emit("Stopped")

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
