import os
import sys

def is_wayland():
    if sys.platform != "linux":
        return False
    return os.environ.get("XDG_SESSION_TYPE") == "wayland" \
        or "WAYLAND_DISPLAY" in os.environ
