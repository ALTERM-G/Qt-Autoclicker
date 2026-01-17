import os
import sys

from PySide6.QtCore import QUrl
from PySide6.QtGui import QFontDatabase, QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QQmlComponent

from backend.controller import Controller

_qml_objects = []
_controller = None


def cleanup():
    global _controller
    if _controller:
        _controller.cleanup_shortcuts()

    for obj in _qml_objects:
        if hasattr(obj, "deleteLater"):
            obj.deleteLater()


def main():
    global _controller
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # --- Load fonts ---
    assets_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets")
    font_dir = os.path.join(assets_path, "fonts")
    if os.path.exists(font_dir):
        for font_filename in os.listdir(font_dir):
            if font_filename.endswith(".ttf"):
                font_path = os.path.join(font_dir, font_filename)
                font_id = QFontDatabase.addApplicationFont(font_path)
                family = QFontDatabase.applicationFontFamilies(font_id)[0]

    # --- Load Data.qml ---
    data_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "data", "Data.qml"
    )
    if os.path.exists(data_path):
        data_component = QQmlComponent(engine, QUrl.fromLocalFile(data_path))
        data_object = data_component.create()
        _qml_objects.append(data_object)
        engine.rootContext().setContextProperty("Data", data_object)

    # --- Controller ---
    controller = Controller()
    _controller = controller
    _qml_objects.append(controller)
    engine.rootContext().setContextProperty("controller", controller)

    # --- Load main.qml ---
    main_qml = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "ui", "main.qml"
    )
    engine.load(QUrl.fromLocalFile(main_qml))

    if not engine.rootObjects():
        sys.exit(-1)

    app.aboutToQuit.connect(cleanup)
    exit_code = app.exec()

    sys.exit(exit_code)


if __name__ == "__main__":
    main()
