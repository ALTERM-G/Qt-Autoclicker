from PySide6.QtCore import QObject, QThread, Signal, Slot
from PySide6.QtGui import QGuiApplication
from pynput import keyboard
from evdev import ecodes

from backend.platform import is_wayland
from backend.Workers.pynput_worker import PynputClickWorker
from backend.Workers.wayland_worker import WaylandClickWorker
from backend.Workers.shortcut_worker import ShortcutWorker
from backend.Workers.wayland_shortcut_worker import WaylandShortcutWorker


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

        if not is_wayland():
            self._shortcut_worker = ShortcutWorker(
                start_key=keyboard.Key.f6,
                stop_key=keyboard.Key.esc
            )
        else:
            self._shortcut_worker = WaylandShortcutWorker(
                start_key=ecodes.KEY_F6,
                stop_key=ecodes.KEY_ESC
            )

        self._shortcut_thread = QThread()
        self._shortcut_worker.moveToThread(self._shortcut_thread)
        self._shortcut_thread.started.connect(self._shortcut_worker.start_listening)
        self._shortcut_worker.start_signal.connect(self.start_clicking_shortcut)
        self._shortcut_worker.stop_signal.connect(self.stop_clicking)
        self._shortcut_thread.start()

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

    def __del__(self):
        if self._shortcut_worker:
            self._shortcut_worker.stop_listening()
        if self._shortcut_thread:
            self._shortcut_thread.quit()
            self._shortcut_thread.wait()
