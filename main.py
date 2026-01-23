import os
import sys

from PySide6.QtCore import QUrl
from PySide6.QtGui import QFontDatabase, QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, QQmlComponent

from backend.controller import Controller

_qml_objects = []
_data_object = None
_controller = None

def cleanup():
    global _controller
    if _controller:
        _controller.stop_clicking()
        _controller.cleanup_shortcuts()

def main():
    global _controller
    import os
    os.environ["QML_XHR_ALLOW_FILE_WRITE"] = "1"
    os.environ["QML_XHR_ALLOW_FILE_READ"] = "1"
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    def load_qml(engine, filename, context_name, callback=None):
        path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", filename)
        if os.path.exists(path):
            component = QQmlComponent(engine, QUrl.fromLocalFile(path))
            obj = component.create()
            if obj:
                engine.rootContext().setContextProperty(context_name, obj)
                if callback:
                    callback(obj)
            return obj
        return None

    # --- Load fonts ---
    assets_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets")
    font_dir = os.path.join(assets_path, "fonts")
    if os.path.exists(font_dir):
        for font_filename in os.listdir(font_dir):
            if font_filename.endswith(".ttf"):
                font_path = os.path.join(font_dir, font_filename)
                font_id = QFontDatabase.addApplicationFont(font_path)
                family = QFontDatabase.applicationFontFamilies(font_id)[0]

    # --- Icons ---
    base_path = os.path.dirname(os.path.abspath(__file__))
    icon_path = os.path.join(base_path, "assets", "icons")
    QIcon.setThemeSearchPaths([icon_path])

    # --- Load QML files ---
    _data_object = load_qml(engine, "Data.qml", "Data", lambda obj: obj.loadSettings())
    _theme_object = load_qml(engine, "Theme.qml", "Theme")
    _svg_library_object = load_qml(engine, "SVGLibrary.qml", "SVGLibrary")

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
