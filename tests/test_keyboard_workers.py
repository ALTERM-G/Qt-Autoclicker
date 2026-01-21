import sys
from unittest.mock import MagicMock, patch

import pytest
from PySide6.QtCore import Signal, QThread

pynput_mock = MagicMock()
sys.modules['pynput'] = pynput_mock
sys.modules['pynput.keyboard'] = pynput_mock.keyboard

wayland_mock = MagicMock()
sys.modules['wayland_automation'] = wayland_mock
sys.modules['wayland_automation.keyboard_controller'] = wayland_mock.keyboard_controller

from backend.workers.keyboard_clicking.pynput_keyboard import PynputKeyboardWorker
from backend.workers.keyboard_clicking.wayland_keyboard import WaylandKeyboardWorker

class MockKeyboard:
    def press(self, key):
        pass
    def release(self, key):
        pass
    def typewrite(self, text, interval):
        pass

@pytest.fixture
def pynput_keyboard_worker(qtbot):
    with patch('pynput.keyboard.Controller', new=MockKeyboard):
        worker = PynputKeyboardWorker(char='a', interval=0.01)
        return worker

def test_pynput_keyboard_worker_init(pynput_keyboard_worker):
    assert pynput_keyboard_worker.char == 'a'
    assert pynput_keyboard_worker.interval == 0.01
    assert not pynput_keyboard_worker.typing

def test_pynput_keyboard_worker_start_stop(pynput_keyboard_worker, qtbot):
    thread = QThread()
    pynput_keyboard_worker.moveToThread(thread)
    thread.started.connect(pynput_keyboard_worker.start_typing)

    with qtbot.waitSignal(pynput_keyboard_worker.finished, timeout=1000):
        thread.start()
        qtbot.wait(100)
        assert pynput_keyboard_worker.typing
        pynput_keyboard_worker.stop_typing()

    thread.quit()
    thread.wait()
    assert not pynput_keyboard_worker.typing

@pytest.fixture
def wayland_keyboard_worker(qtbot):
    with patch('wayland_automation.keyboard_controller.Keyboard', new=MockKeyboard):
        worker = WaylandKeyboardWorker(char='b', interval=0.02)
        return worker

def test_wayland_keyboard_worker_init(wayland_keyboard_worker):
    assert wayland_keyboard_worker.char == 'b'
    assert wayland_keyboard_worker.interval == 0.02
    assert not wayland_keyboard_worker.typing

def test_wayland_keyboard_worker_start_stop(wayland_keyboard_worker, qtbot):
    thread = QThread()
    wayland_keyboard_worker.moveToThread(thread)
    thread.started.connect(wayland_keyboard_worker.start_typing)

    with qtbot.waitSignal(wayland_keyboard_worker.finished, timeout=1000):
        thread.start()
        qtbot.wait(100)
        assert wayland_keyboard_worker.typing
        wayland_keyboard_worker.stop_typing()

    thread.quit()
    thread.wait()
    assert not wayland_keyboard_worker.typing
