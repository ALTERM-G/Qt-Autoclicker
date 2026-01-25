# Qt Autoclicker

A simple and modern autoclicker for mouse and keyboard, built with Python and Qt. It provides a clean user interface to configure and run automated clicking or typing tasks.

## Features

-   Automate mouse clicks (left or right button) at a high speed.
-   Automate keyboard key presses at a configurable rate.
-   Set global shortcuts to start and stop the automation from any application.
-   Clean and intuitive user interface.
-   Great UX with a theme system. New themes can be easily added in `Theme.qml`.
-   Support for both Wayland and X11 display servers on Linux.

## Requirements

*   Python 3.8+
*   PySide6
*   pynput
*   evdev (for Wayland support on Linux)

## Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/your-username/Qt-Autoclicker.git
    cd Qt-Autoclicker
    ```

2.  Install the required Python packages.

    **Option 1: Using pip (Standard)**

    ```bash
    pip install -r requirements.txt
    ```

    **Option 2: Using uv (Recommended & Faster)**

    If you have `uv` installed, you can use `uv sync` to install the exact locked versions from `uv.lock`.

    ```bash
    uv sync
    ```

## Usage

To run the application, execute the `main.py` script:

```bash
python main.py
```

## Platform Support

The application is primarily developed and tested on Linux (Wayland and X11).

It should also work on other operating systems like Windows and macOS in non-Wayland environments where `pynput` is supported, though this has not been formally tested.
