#!/usr/bin/env python3
from evdev import InputDevice, ecodes, list_devices
import select
import sys

TARGET_KEY = ecodes.KEY_F6
fd_to_dev = {}

for path in list_devices():
    dev = InputDevice(path)
    if ecodes.EV_KEY in dev.capabilities():
        fd_to_dev[dev.fd] = dev
print("Listening for F6... (Ctrl+C to exit)")

while True:
    ready_fds, _, _ = select.select(fd_to_dev.keys(), [], [])
    for fd in ready_fds:
        dev = fd_to_dev[fd]
        for event in dev.read():
            if (
                event.type == ecodes.EV_KEY
                and event.code == TARGET_KEY
                and event.value == 1
            ):
                print(f"F6 pressed on {dev.name}, exiting.")
                sys.exit(0)
