import os
import sys

from PySide6.QtCore import QUrl
from PySide6.QtGui import QFontDatabase, QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType


def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    assets_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets")
    font_dir = os.path.join(assets_path, "fonts")
    for font_filename in os.listdir(font_dir):
        if font_filename.endswith(".ttf"):
            font_path = os.path.join(font_dir, font_filename)
            font_id = QFontDatabase.addApplicationFont(font_path)
            family = QFontDatabase.applicationFontFamilies(font_id)[0]

    data_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "data", "Data.qml"
    )
    qmlRegisterSingletonType(QUrl.fromLocalFile(data_path), "Data", 1, 0, "Data")

    main_qml = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "ui", "main.qml"
    )
    engine.load(QUrl.fromLocalFile(main_qml))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
