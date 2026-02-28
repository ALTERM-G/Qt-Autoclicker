from PySide6.QtCore import QObject, Signal
import time
from wayland_automation.keyboard_controller import Keyboard

class WaylandKeyboardWorker(QObject):
    finished = Signal()
    status = Signal(str)

    def __init__(self, char, interval=0.1):
        super().__init__()
        self.char = char
        self.interval = interval
        self.typing = False
        self.keyboard = Keyboard()

    def start_typing(self):
        self.typing = True
        self.status.emit(f"Wayland typing '{self.char}' started")
        try:
            while self.typing:
                self.keyboard.typewrite(self.char, interval=self.interval)
        finally:
            self.finished.emit()

    def stop_typing(self):
        self.typing = False
