import sys
from unittest.mock import MagicMock, patch

import pytest
from PySide6.QtCore import Signal, QThread

pynput_mock = MagicMock()
pynput_mock.mouse.Button.left.name = 'left'
pynput_mock.mouse.Button.right.name = 'right'
sys.modules['pynput'] = pynput_mock
sys.modules['pynput.mouse'] = pynput_mock.mouse

wayland_mock = MagicMock()
sys.modules['wayland_automation'] = wayland_mock
sys.modules['wayland_automation.mouse_controller'] = wayland_mock.mouse_controller

from backend.workers.mouse_clicking.pynput_mouse import PynputClickWorker
from backend.workers.mouse_clicking.wayland_mouse import WaylandClickWorker

class MockMouse:
    def __init__(self):
        self.position = (0, 0)
    def press(self, button):
        pass
    def release(self, button):
        pass

@pytest.fixture
def pynput_worker(qtbot):
    with patch('pynput.mouse.Controller', new=MockMouse):
        worker = PynputClickWorker(button='left', interval=0.01)
        return worker

def test_pynput_worker_init(pynput_worker):
    assert pynput_worker.button.name == 'left'
    assert pynput_worker.interval == 0.01
    assert not pynput_worker.clicking

def test_pynput_worker_start_stop(pynput_worker, qtbot):
    thread = QThread()
    pynput_worker.moveToThread(thread)
    thread.started.connect(pynput_worker.start_clicking)

    with qtbot.waitSignal(pynput_worker.finished, timeout=1000):
        thread.start()
        qtbot.wait(100)
        assert pynput_worker.clicking
        pynput_worker.stop_clicking()

    thread.quit()
    thread.wait()
    assert not pynput_worker.clicking

@pytest.fixture
def wayland_worker(qtbot):
    with patch('wayland_automation.mouse_controller.Mouse'):
        worker = WaylandClickWorker(button='right', interval=0.02, x=100, y=200)
        return worker

def test_wayland_worker_init(wayland_worker):
    assert wayland_worker.button == 'right'
    assert wayland_worker.interval == 0.02
    assert wayland_worker.x == 100
    assert wayland_worker.y == 200
    assert not wayland_worker.clicking

def test_wayland_worker_start_stop(wayland_worker, qtbot):
    thread = QThread()
    wayland_worker.moveToThread(thread)
    thread.started.connect(wayland_worker.start_clicking)

    with qtbot.waitSignal(wayland_worker.finished, timeout=1000):
        thread.start()
        qtbot.wait(100)
        assert wayland_worker.clicking
        wayland_worker.stop_clicking()

    thread.quit()
    thread.wait()
    assert not wayland_worker.clicking
