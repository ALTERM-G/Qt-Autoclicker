from PySide6.QtCore import QObject, Signal
from pynput.mouse import Controller, Button
import time

class PynputClickWorker(QObject):
    finished = Signal()
    status = Signal(str)

    def __init__(self, button="left", interval=0.05):
        super().__init__()
        self.interval = interval
        self.clicking = False
        self.mouse = Controller()

        buttons = {
            "left": Button.left,
            "right": Button.right,
        }
        self.button = buttons.get(button, Button.left)

    def start_clicking(self):
        self.clicking = True
        self.status.emit(f"Clicking {self.button.name} started (pynput)")
        while self.clicking:
            self.mouse.click(self.button)
            time.sleep(self.interval)
        self.finished.emit()

    def stop_clicking(self):
        self.clicking = False
