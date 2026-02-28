from PySide6.QtCore import QObject, Signal
import time
from wayland_automation import Mouse

class WaylandClickWorker(QObject):
    finished = Signal()
    status = Signal(str)

    def __init__(self, button="left", interval=0.05, x=0, y=0):
        super().__init__()
        self.interval = interval
        self.button = button
        self.x = x
        self.y = y
        self.clicking = False
        self.mouse = Mouse()

    def start_clicking(self):
        self.clicking = True
        self.status.emit(
            f"Wayland clicking {self.button} at ({self.x}, {self.y})"
        )

        try:
            while self.clicking:
                self.mouse.click(self.x, self.y, self.button)
                time.sleep(self.interval)
        finally:
            self.finished.emit()

    def stop_clicking(self):
        self.clicking = False
