from .pynput_mouse import PynputClickWorker

try:
    from .wayland_mouse import WaylandClickWorker
except ImportError:
    WaylandClickWorker = None

__all__ = ["PynputClickWorker", "WaylandClickWorker"]
