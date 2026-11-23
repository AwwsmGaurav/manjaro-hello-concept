# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Gaurav Kalambe (@AwwsmGaurav)
# Project: Manjaro / CachyOS Hello UI/UX Concept Mockup

import json
import sys
from pathlib import Path

from PySide6.QtCore import Property, QObject, QUrl, Slot
from PySide6.QtGui import QDesktopServices, QFont, QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle

BASE_DIR = Path(__file__).resolve().parent


def parse_cli_args(argv: list[str]) -> tuple[bool, float, float]:
    solid = "--solid" in argv
    opacity = 0.92
    blur = 0.65

    if "--opacity" in argv:
        idx = argv.index("--opacity")
        if idx + 1 < len(argv):
            try:
                opacity = max(0.2, min(1.0, float(argv[idx + 1])))
            except ValueError:
                pass

    if "--blur" in argv:
        idx = argv.index("--blur")
        if idx + 1 < len(argv):
            try:
                blur = max(0.0, min(1.0, float(argv[idx + 1])))
            except ValueError:
                pass

    return solid, opacity, blur


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

    @Property(list, constant=True)  # type: ignore[arg-type]
    def categories(self):
        return self._apps_data

    @Slot(str)
    def openUrl(self, url: str):
        QDesktopServices.openUrl(QUrl(url))

    @Slot(str)
    def copyToClipboard(self, text: str):
        QGuiApplication.clipboard().setText(text)

    @Slot(list, result=str)
    def buildInstallCommand(self, packages: list):
        if not packages:
            return ""
        pkgs = " ".join(packages)
        return f"pamac install --no-confirm {pkgs}"


def main():
    QQuickStyle.setStyle("Basic")
    app = QGuiApplication(sys.argv)
    app.setApplicationName("Manjaro Hello Concept")

    solid_mode, glass_opacity, glass_blur = parse_cli_args(sys.argv)

    ui_font = QFont("Noto Sans")
    ui_font.setStyleHint(QFont.StyleHint.SansSerif)
    app.setFont(ui_font)

    engine = QQmlApplicationEngine()
    backend = Backend(engine)
    engine.rootContext().setContextProperty("backend", backend)
    engine.rootContext().setContextProperty("defaultSolidMode", solid_mode)
    engine.rootContext().setContextProperty("defaultGlassOpacity", glass_opacity)
    engine.rootContext().setContextProperty("defaultGlassBlur", glass_blur)

    qml_file = BASE_DIR / "ui" / "Main.qml"
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
