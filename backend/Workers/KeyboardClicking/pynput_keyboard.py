from PySide6.QtCore import QObject, Signal
from pynput.keyboard import Controller, Key
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

        special_keys = {
            " ": Key.space,
            "\n": Key.enter,
            "\t": Key.tab,
            "\b": Key.backspace,
        }
        key_to_type = special_keys.get(self.char, self.char)

        while self.typing:
            self.keyboard.press(key_to_type)
            self.keyboard.release(key_to_type)
            time.sleep(self.interval)
        self.finished.emit()

    def stop_typing(self):
        self.typing = False
