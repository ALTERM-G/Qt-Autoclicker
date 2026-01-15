from PySide6.QtCore import QObject, QThread, Signal, Slot
from PySide6.QtGui import QGuiApplication
from backend.platform import is_wayland
from backend.Workers.pynput_worker import PynputClickWorker
from backend.Workers.wayland_worker import WaylandClickWorker

class Controller(QObject):
    status_update = Signal(str)

    def __init__(self):
        super().__init__()
        self._thread = None
        self._worker = None

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
        self._thread.quit()
        self._thread.wait()
        self._worker.deleteLater()
        self._thread.deleteLater()
        self._worker = None
        self._thread = None
        self.status_update.emit("Stopped")
