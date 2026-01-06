import os
import sys
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType

def main():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    data_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", "Data.qml")
    qmlRegisterSingletonType(QUrl.fromLocalFile(data_path), "Data", 1, 0, "Data")

    main_qml = os.path.join(os.path.dirname(os.path.abspath(__file__)), "ui", "main.qml")
    engine.load(QUrl.fromLocalFile(main_qml))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())

if __name__ == "__main__":
    main()
