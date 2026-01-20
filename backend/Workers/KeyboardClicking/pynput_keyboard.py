from PySide6.QtCore import QObject, Signal
from pynput.keyboard import Controller
import time


class PynputKeyboardWorker(QObject):
    finished = Signal()
    status = Signal(str)

    def __init__(self, char="a", interval=0.1):
        super().__init__()
        self.char = char
        self.interval = interval
        self.typing = False
        self.keyboard = Controller()

    def start_typing(self):
        self.typing = True
        self.status.emit(f"Typing '{self.char}' started (pynput)")
        while self.typing:
            self.keyboard.press(self.char)
            self.keyboard.release(self.char)
            time.sleep(self.interval)
        self.finished.emit()

    def stop_typing(self):
        self.typing = False
