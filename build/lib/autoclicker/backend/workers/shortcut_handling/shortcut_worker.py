from PySide6.QtCore import QObject, Signal
from pynput import keyboard

class ShortcutWorker(QObject):
    start_signal = Signal()
    stop_signal = Signal()

    def __init__(self, start_key, stop_key):
        super().__init__()
        self._start_key = start_key
        self._stop_key = stop_key
        self._listener = None
        self._enabled = True

    def set_enabled(self, enabled):
        self._enabled = enabled

    def start_listening(self):
        self._listener = keyboard.Listener(on_press=self._on_press)
        self._listener.start()

    def stop_listening(self):
        if self._listener:
            self._listener.stop()

    def _on_press(self, key):
        if not self._enabled:
            return
        if key == self._start_key:
            self.start_signal.emit()
        elif key == self._stop_key:
            self.stop_signal.emit()
