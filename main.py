import json
import sys
from pathlib import Path
from PySide6.QtCore import QObject, QUrl, Slot, Property
from PySide6.QtGui import QDesktopServices, QFont, QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle

BASE_DIR = Path(__file__).resolve().parent


class Backend(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._apps_data = self._load_apps()

    def _load_apps(self):
        apps_file = BASE_DIR / "data" / "apps.json"
        if apps_file.exists():
            with open(apps_file, "r", encoding="utf-8") as f:
                return json.load(f).get("categories", [])
        return []

    @Property("QVariantList", constant=True)
    def categories(self):
        return self._apps_data

    @Slot(str)
    def openUrl(self, url: str):
        QDesktopServices.openUrl(QUrl(url))

    @Slot(str)
    def copyToClipboard(self, text: str):
        QGuiApplication.clipboard().setText(text)

    @Slot("QVariantList", result=str)
    def buildInstallCommand(self, packages: list):
        if not packages:
            return ""
        pkgs = " ".join(packages)
        return f"pamac install --no-confirm {pkgs}"


def main():
    QQuickStyle.setStyle("Basic")
    app = QGuiApplication(sys.argv)
    app.setApplicationName("Manjaro Hello Concept")

    ui_font = QFont("Noto Sans")
    ui_font.setStyleHint(QFont.SansSerif)
    app.setFont(ui_font)

    engine = QQmlApplicationEngine()
    backend = Backend(engine)
    engine.rootContext().setContextProperty("backend", backend)

    qml_file = BASE_DIR / "ui" / "Main.qml"
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()