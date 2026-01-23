from .shortcut_worker import ShortcutWorker

try:
    from .wayland_shortcut_worker import WaylandShortcutWorker
except ImportError:
    WaylandShortcutWorker = None

__all__ = ["ShortcutWorker", "WaylandShortcutWorker"]
