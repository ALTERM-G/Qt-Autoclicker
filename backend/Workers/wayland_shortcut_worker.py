from PySide6.QtCore import QObject, Signal
from evdev import InputDevice, ecodes, list_devices
import select


class WaylandShortcutWorker(QObject):
    start_signal = Signal()
    stop_signal = Signal()

    def __init__(self, start_key=ecodes.KEY_F6, stop_key=ecodes.KEY_ESC):
        super().__init__()
        self._start_key = start_key
        self._stop_key = stop_key
        self._running = False
        self._devices = {}

    def start_listening(self):
        self._running = True
        self._open_devices()

        while self._running:
            if not self._devices:
                continue

            r, _, _ = select.select(self._devices.keys(), [], [], 0.1)
            for fd in r:
                dev = self._devices[fd]
                for event in dev.read():
                    if event.type != ecodes.EV_KEY:
                        continue

                    if event.value != 1:
                        continue

                    if event.code == self._start_key:
                        self.start_signal.emit()
                    elif event.code == self._stop_key:
                        self.stop_signal.emit()

    def stop_listening(self):
        self._running = False
        for dev in self._devices.values():
            dev.close()
        self._devices.clear()

    def _open_devices(self):
        for path in list_devices():
            dev = InputDevice(path)
            if ecodes.EV_KEY in dev.capabilities():
                self._devices[dev.fd] = dev
