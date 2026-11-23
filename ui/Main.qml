// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Gaurav Kalambe (@AwwsmGaurav)
// Project: Manjaro / CachyOS Hello UI/UX Concept Mockup

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 980
    height: 620
    minimumWidth: 880
    minimumHeight: 560
    visible: true
    title: "Welcome to Manjaro"
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.Window
    font.family: "Noto Sans"

    // Official Manjaro palette (#35BFA4)
    readonly property color accentGreen: "#35BFA4"
    readonly property color accentHover: "#42D6B8"
    property bool solidMode: typeof defaultSolidMode !== "undefined" ? defaultSolidMode : false
    readonly property color glassBg: solidMode ? "#FF151A1F" : "#E8151A1F"
    readonly property color cardBg: solidMode ? "#FF1D242B" : "#CC1D242B"
    readonly property color cardBorder: "#2AFFFFFF"
    readonly property color textPrimary: "#F0F4F8"
    readonly property color textMuted: "#9BA8B4"

    property var selectedApps: ({})
    property int selectedCount: 0
    property int expandedCategory: -1
    property string previewCmd: ""
    property bool copiedFeedback: false

    function toggleApp(appId) {
        let copy = Object.assign({}, selectedApps)
        if (copy[appId]) {
            delete copy[appId]
        } else {
            copy[appId] = true
        }
        selectedApps = copy
        selectedCount = Object.keys(copy).length
        copiedFeedback = false
        if (previewCmd !== "") {
            previewCmd = backend.buildInstallCommand(Object.keys(copy))
        }
    }

    Timer {
        id: copyResetTimer
        interval: 1800
        onTriggered: copiedFeedback = false
    }

    // Keyboard navigation
    Shortcut {
        sequence: "Right"
        onActivated: if (swipeView.currentIndex < swipeView.count - 1) swipeView.currentIndex++
    }
    Shortcut {
        sequence: "Left"
        onActivated: if (swipeView.currentIndex > 0) swipeView.currentIndex--
    }
    Shortcut {
        sequence: "Escape"
        onActivated: Qt.quit()
    }

    // Main translucent/solid container
    Rectangle {
        anchors.fill: parent
        color: glassBg
        radius: 16
        border.color: "#28FFFFFF"
        border.width: 1
        clip: true

        Behavior on color { ColorAnimation { duration: 180 } }

        // Subtle decorative curved accents in background
        Canvas {
            anchors.fill: parent
            opacity: 0.13
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.fillStyle = accentGreen

                // Top-left organic curve
                ctx.beginPath()
                ctx.moveTo(0, 0)
                ctx.lineTo(300, 0)
                ctx.bezierCurveTo(200, 110, 70, 80, 0, 210)
                ctx.closePath()
                ctx.fill()

                // Bottom-right organic curve
                ctx.beginPath()
                ctx.moveTo(width, height)
                ctx.lineTo(width - 340, height)
                ctx.bezierCurveTo(width - 190, height - 100, width - 80, height - 60, width, height - 230)
                ctx.closePath()
                ctx.fill()
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // ================= FRAMELESS DRAGGABLE TOP BAR =================
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 46

                MouseArea {
                    anchors.fill: parent
                    onPressed: root.startSystemMove()
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 22
                    anchors.rightMargin: 16
                    spacing: 12

                    Rectangle { width: 9; height: 9; radius: 5; color: accentGreen }
                    Label {
                        text: "MANJARO HELLO  •  CONCEPT"
                        color: textMuted
                        font.pixelSize: 11
                        font.letterSpacing: 1.4
                        font.bold: true
                    }
                    Item { Layout.fillWidth: true }

                    // Subtle Transparency / Accessibility Toggle
                    Button {
                        text: solidMode ? "◐ Glass" : "● Solid"
                        flat: true
                        leftPadding: 8; rightPadding: 8; topPadding: 4; bottomPadding: 4
                        contentItem: Text {
                            text: parent.text
                            color: parent.hovered ? textPrimary : textMuted
                            font.pixelSize: 11
                        }
                        background: Rectangle {
                            radius: 6
                            color: parent.hovered ? "#1AFFFFFF" : "transparent"
                        }
                        onClicked: solidMode = !solidMode
                    }

                    Button {
                        text: "Skip"
                        visible: swipeView.currentIndex < swipeView.count - 1
                        flat: true
                        contentItem: Text {
                            text: parent.text
                            color: parent.hovered ? textPrimary : textMuted
                            font.pixelSize: 12
                        }
                        background: Item {}
                        onClicked: swipeView.currentIndex = swipeView.count - 1
                    }

                    // Frameless Close Button
                    Button {
                        width: 28; height: 28
                        flat: true
                        contentItem: Text {
                            text: "✕"
                            color: parent.hovered ? "#FFFFFF" : textMuted
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            radius: 14
                            color: parent.hovered ? "#CCEF5350" : "#18FFFFFF"
                        }
                        onClicked: Qt.quit()
                    }
                }
            }

            // ================= MAIN SPLIT: 2/3 CONTENT + 1/3 MASCOT =================
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // LEFT 2/3: Horizontal SwipeView
                SwipeView {
                    id: swipeView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.66
                    clip: true

                    // ================= CARD 1: WELCOME =================
                    Item {
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 48
                            anchors.rightMargin: 24
                            spacing: 0

                            Item { Layout.fillHeight: true; Layout.preferredHeight: 2 }

                            RowLayout {
                                spacing: 22
                                Item {
                                    width: 76; height: 76
                                    Rectangle { x: 0;  y: 0;  width: 46; height: 22; radius: 4; color: accentGreen }
                                    Rectangle { x: 0;  y: 0;  width: 22; height: 76; radius: 4; color: accentGreen }
                                    Rectangle { x: 27; y: 27; width: 22; height: 49; radius: 4; color: accentGreen }
                                    Rectangle { x: 54; y: 0;  width: 22; height: 76; radius: 4; color: accentGreen }
                                }
                                ColumnLayout {
                                    spacing: 4
                                    Label {
                                        text: "Welcome to Manjaro"
                                        color: textPrimary
                                        font.pixelSize: 36
                                        font.bold: true
                                    }
                                    Label {
                                        text: "Free, open, and built for everyone."
                                        color: accentGreen
                                        font.pixelSize: 16
                                        font.weight: Font.Medium
                                    }
                                }
                            }

                            Item { Layout.preferredHeight: 46 }

                            Label {
                                Layout.fillWidth: true
                                text: "Thank you for choosing Manjaro. Whether you're here to create, code, game, or just enjoy a fast and reliable desktop, you're in good hands.\n\nTake 30 seconds to swipe through these cards—we'll get you comfortable, safe, and equipped with your favorite FOSS tools."
                                color: textMuted
                                font.pixelSize: 15
                                lineHeight: 1.55
                                wrapMode: Text.WordWrap
                            }

                            Item { Layout.fillHeight: true; Layout.preferredHeight: 3 }
                        }
                    }

                    // ================= CARD 2: 30-SECOND SURVIVAL GUIDE (3 CIRCLES) =================
                    Item {
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 36
                            anchors.rightMargin: 20
                            anchors.topMargin: 10
                            anchors.bottomMargin: 14
                            spacing: 10

                            ColumnLayout {
                                spacing: 3
                                Label {
                                    text: "The 30-Second Survival Guide"
                                    color: textPrimary
                                    font.pixelSize: 24
                                    font.bold: true
                                }
                                Label {
                                    text: "Three simple habits that keep Manjaro rock-solid for years."
                                    color: textMuted
                                    font.pixelSize: 13
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                // Circle 1: Top-Left (Rolling Release)
                                Rectangle {
                                    width: 186; height: 186; radius: 93
                                    x: Math.max(8, parent.width * 0.04)
                                    y: Math.max(4, parent.height * 0.04)
                                    color: cardBg
                                    border.color: "#5535BFA4"
                                    border.width: 1.5

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        width: parent.width - 36
                                        spacing: 6
                                        Label { Layout.alignment: Qt.AlignHCenter; text: "🔄"; font.pixelSize: 24 }
                                        Label {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: "Rolling Release"
                                            color: textPrimary
                                            font.pixelSize: 14
                                            font.bold: true
                                        }
                                        Label {
                                            Layout.fillWidth: true
                                            horizontalAlignment: Text.AlignHCenter
                                            text: "No reinstalling. Just update regularly via Pamac."
                                            color: textMuted
                                            font.pixelSize: 12
                                            lineHeight: 1.3
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }

                                // Circle 2: Bottom-Center (No Random Commands)
                                Rectangle {
                                    width: 194; height: 194; radius: 97
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    y: Math.max(120, parent.height - height - 8)
                                    color: solidMode ? "#FF1E2927" : "#D91E2927"
                                    border.color: accentGreen
                                    border.width: 1.5

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        width: parent.width - 36
                                        spacing: 6
                                        Label { Layout.alignment: Qt.AlignHCenter; text: "🛡️"; font.pixelSize: 24 }
                                        Label {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: "No Random Scripts"
                                            color: textPrimary
                                            font.pixelSize: 14
                                            font.bold: true
                                        }
                                        Label {
                                            Layout.fillWidth: true
                                            horizontalAlignment: Text.AlignHCenter
                                            text: "Use the built-in store first instead of random terminal commands."
                                            color: textMuted
                                            font.pixelSize: 12
                                            lineHeight: 1.3
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }

                                // Circle 3: Top-Right (Safety Net)
                                Rectangle {
                                    width: 186; height: 186; radius: 93
                                    x: Math.min(parent.width - width - 8, parent.width * 0.96 - width)
                                    y: Math.max(12, parent.height * 0.08)
                                    color: cardBg
                                    border.color: "#5535BFA4"
                                    border.width: 1.5

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        width: parent.width - 36
                                        spacing: 6
                                        Label { Layout.alignment: Qt.AlignHCenter; text: "⏱️"; font.pixelSize: 24 }
                                        Label {
                                            Layout.alignment: Qt.AlignHCenter
                                            text: "Your Safety Net"
                                            color: textPrimary
                                            font.pixelSize: 14
                                            font.bold: true
                                        }
                                        Label {
                                            Layout.fillWidth: true
                                            horizontalAlignment: Text.AlignHCenter
                                            text: "Set up Timeshift once to roll back any update in seconds."
                                            color: textMuted
                                            font.pixelSize: 12
                                            lineHeight: 1.3
                                            wrapMode: Text.WordWrap
                                        }
                                    }
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 3
                                Label {
                                    text: "GOLDEN ADVICE"
                                    color: accentGreen
                                    font.pixelSize: 10
                                    font.bold: true
                                    font.letterSpacing: 1.2
                                }
                                Label {
                                    Layout.fillWidth: true
                                    text: "• Glance at Forum Announcements before big updates   • Keep a spare LTS kernel   • Reboot after kernel updates"
                                    color: textMuted
                                    font.pixelSize: 12
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }

                    // ================= CARD 3: SLANTED ACCORDION FOSS APPS =================
                    Item {
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 36
                            anchors.rightMargin: 20
                            anchors.topMargin: 10
                            anchors.bottomMargin: 12
                            spacing: 12

                            ColumnLayout {
                                spacing: 2
                                Label {
                                    text: "Grab Your FOSS Apps"
                                    color: textPrimary
                                    font.pixelSize: 24
                                    font.bold: true
                                }
                                Label {
                                    text: "Optional convenience picks—zero affiliation, zero bloat on the ISO."
                                    color: textMuted
                                    font.pixelSize: 12
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: cardBg
                                radius: 14
                                border.color: cardBorder
                                clip: true

                                Flickable {
                                    id: appsFlick
                                    anchors.fill: parent
                                    contentWidth: width
                                    contentHeight: Math.max(height, accordionCol.implicitHeight)
                                    clip: true
                                    boundsBehavior: Flickable.StopAtBounds
                                    ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                                    Item {
                                        width: appsFlick.width
                                        height: appsFlick.contentHeight

                                        Column {
                                            id: accordionCol
                                            width: parent.width
                                            anchors.verticalCenter: parent.verticalCenter

                                            Repeater {
                                                model: backend ? backend.categories : []

                                                Column {
                                                    width: accordionCol.width
                                                    property bool isExpanded: expandedCategory === index
                                                    property var catApps: modelData.apps

                                                    Rectangle {
                                                        width: parent.width
                                                        height: 76
                                                        color: headerMa.containsMouse ? "#14FFFFFF" : "transparent"

                                                        MouseArea {
                                                            id: headerMa
                                                            anchors.fill: parent
                                                            hoverEnabled: true
                                                            cursorShape: Qt.PointingHandCursor
                                                            onClicked: expandedCategory = (expandedCategory === index ? -1 : index)
                                                        }

                                                        RowLayout {
                                                            anchors.fill: parent
                                                            anchors.leftMargin: 24
                                                            anchors.rightMargin: 24
                                                            spacing: 16

                                                            Label { text: modelData.emoji; font.pixelSize: 26 }
                                                            ColumnLayout {
                                                                spacing: 1
                                                                Label {
                                                                    text: modelData.name
                                                                    color: isExpanded ? accentGreen : textPrimary
                                                                    font.pixelSize: 17
                                                                    font.bold: true
                                                                }
                                                                Label {
                                                                    text: catApps.length + " curated picks"
                                                                    color: textMuted
                                                                    font.pixelSize: 12
                                                                }
                                                            }
                                                            Item { Layout.fillWidth: true }

                                                            Row {
                                                                spacing: 8
                                                                Label {
                                                                    text: isExpanded ? "Hide" : "Explore"
                                                                    color: textMuted
                                                                    font.pixelSize: 12
                                                                    anchors.verticalCenter: parent.verticalCenter
                                                                }
                                                                Label {
                                                                    text: "❯"
                                                                    color: isExpanded ? accentGreen : textMuted
                                                                    font.pixelSize: 15
                                                                    font.bold: true
                                                                    rotation: isExpanded ? 90 : 0
                                                                    Behavior on rotation { NumberAnimation { duration: 180 } }
                                                                }
                                                            }
                                                        }
                                                    }

                                                    Column {
                                                        width: parent.width
                                                        visible: isExpanded
                                                        spacing: 0

                                                        Repeater {
                                                            model: catApps
                                                            Rectangle {
                                                                property bool isChecked: !!selectedApps[modelData.id]
                                                                width: parent.width
                                                                height: 54
                                                                color: isChecked ? "#1A35BFA4" : (appMa.containsMouse ? "#0DFFFFFF" : "transparent")

                                                                MouseArea {
                                                                    id: appMa
                                                                    anchors.fill: parent
                                                                    hoverEnabled: true
                                                                    cursorShape: Qt.PointingHandCursor
                                                                    onClicked: root.toggleApp(modelData.id)
                                                                }

                                                                RowLayout {
                                                                    anchors.fill: parent
                                                                    anchors.leftMargin: 28
                                                                    anchors.rightMargin: 24
                                                                    spacing: 14

                                                                    Rectangle {
                                                                        width: 36; height: 36; radius: 8
                                                                        color: "#22FFFFFF"
                                                                        Label {
                                                                            anchors.centerIn: parent
                                                                            text: modelData.icon
                                                                            font.pixelSize: 20
                                                                        }
                                                                    }

                                                                    ColumnLayout {
                                                                        Layout.fillWidth: true
                                                                        spacing: 1
                                                                        RowLayout {
                                                                            spacing: 8
                                                                            Label {
                                                                                text: modelData.name
                                                                                color: textPrimary
                                                                                font.pixelSize: 14
                                                                                font.bold: true
                                                                            }
                                                                            Rectangle {
                                                                                visible: modelData.proprietary
                                                                                color: "#33FF9800"
                                                                                border.color: "#88FF9800"
                                                                                radius: 4
                                                                                implicitWidth: propText.implicitWidth + 8
                                                                                implicitHeight: 16
                                                                                Label {
                                                                                    id: propText
                                                                                    anchors.centerIn: parent
                                                                                    text: "Proprietary"
                                                                                    color: "#FFB74D"
                                                                                    font.pixelSize: 9
                                                                                }
                                                                            }
                                                                        }
                                                                        Label {
                                                                            text: modelData.desc
                                                                            color: textMuted
                                                                            font.pixelSize: 11
                                                                            elide: Text.ElideRight
                                                                            Layout.fillWidth: true
                                                                        }
                                                                    }

                                                                    Rectangle {
                                                                        width: 20; height: 20; radius: 5
                                                                        color: isChecked ? accentGreen : "transparent"
                                                                        border.color: isChecked ? accentGreen : "#66FFFFFF"
                                                                        border.width: 1.5
                                                                        Label {
                                                                            anchors.centerIn: parent
                                                                            text: "✓"
                                                                            color: "#111"
                                                                            font.pixelSize: 12
                                                                            font.bold: true
                                                                            visible: isChecked
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }

                                                    Canvas {
                                                        visible: index < (backend ? backend.categories.length - 1 : 0)
                                                        width: parent.width
                                                        height: 22
                                                        onWidthChanged: requestPaint()
                                                        onPaint: {
                                                            var ctx = getContext("2d")
                                                            ctx.reset()
                                                            ctx.strokeStyle = "#5535BFA4"
                                                            ctx.lineWidth = 1.5
                                                            ctx.beginPath()
                                                            ctx.moveTo(0, height - 2)
                                                            ctx.lineTo(width, 2)
                                                            ctx.stroke()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: cmdRow.implicitHeight + 16
                                radius: 10
                                color: "#1A000000"
                                border.color: previewCmd !== "" ? "#4435BFA4" : "#1AFFFFFF"

                                RowLayout {
                                    id: cmdRow
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    anchors.leftMargin: 12
                                    spacing: 10

                                    Label {
                                        Layout.fillWidth: true
                                        text: previewCmd !== "" ? previewCmd : (selectedCount + " app(s) selected — click Preview to build your Pamac command")
                                        color: previewCmd !== "" ? accentGreen : textMuted
                                        font.pixelSize: 12
                                        font.family: previewCmd !== "" ? "monospace" : "Noto Sans"
                                        wrapMode: Text.Wrap
                                        maximumLineCount: 3
                                        elide: Text.ElideRight
                                    }

                                    Button {
                                        visible: previewCmd !== ""
                                        text: copiedFeedback ? "Copied ✓" : "Copy"
                                        leftPadding: 12; rightPadding: 12; topPadding: 6; bottomPadding: 6
                                        contentItem: Text {
                                            text: parent.text
                                            color: copiedFeedback ? accentGreen : textPrimary
                                            font.pixelSize: 12
                                            font.bold: true
                                        }
                                        background: Rectangle {
                                            radius: 7
                                            color: "#22FFFFFF"
                                            border.color: copiedFeedback ? accentGreen : "#33FFFFFF"
                                        }
                                        onClicked: {
                                            backend.copyToClipboard(previewCmd)
                                            copiedFeedback = true
                                            copyResetTimer.restart()
                                        }
                                    }

                                    Button {
                                        text: "Preview Command"
                                        enabled: selectedCount > 0
                                        opacity: enabled ? 1.0 : 0.4
                                        leftPadding: 12; rightPadding: 12; topPadding: 6; bottomPadding: 6
                                        contentItem: Text {
                                            text: parent.text
                                            color: "#111"
                                            font.pixelSize: 12
                                            font.bold: true
                                        }
                                        background: Rectangle { radius: 7; color: accentGreen }
                                        onClicked: {
                                            previewCmd = backend.buildInstallCommand(Object.keys(selectedApps))
                                            copiedFeedback = false
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // ================= CARD 4: COMMUNITY (CENTERED + FORUM SPOTLIGHT) =================
                    Item {
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 44
                            anchors.rightMargin: 24
                            spacing: 0

                            Item { Layout.fillHeight: true }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 10

                                RowLayout {
                                    spacing: 10
                                    Label {
                                        text: "THE HEART OF MANJARO"
                                        color: accentGreen
                                        font.pixelSize: 11
                                        font.bold: true
                                        font.letterSpacing: 1.5
                                    }
                                    Rectangle {
                                        color: "#2235BFA4"
                                        border.color: "#5535BFA4"
                                        radius: 6
                                        implicitWidth: urlLbl.implicitWidth + 14
                                        implicitHeight: 22
                                        Label {
                                            id: urlLbl
                                            anchors.centerIn: parent
                                            text: "forum.manjaro.org"
                                            color: accentGreen
                                            font.pixelSize: 11
                                            font.family: "monospace"
                                            font.bold: true
                                        }
                                    }
                                }

                                Label {
                                    text: "Join the Manjaro Forum"
                                    color: textPrimary
                                    font.pixelSize: 32
                                    font.bold: true
                                }
                                Label {
                                    Layout.fillWidth: true
                                    text: "Stuck on a setup step, checking update announcements, or want to share feedback? Our community forum is where users and developers hang out every single day."
                                    color: textMuted
                                    font.pixelSize: 14
                                    lineHeight: 1.48
                                    wrapMode: Text.WordWrap
                                }
                                Button {
                                    Layout.topMargin: 6
                                    text: "Visit forum.manjaro.org  →"
                                    leftPadding: 20; rightPadding: 20; topPadding: 10; bottomPadding: 10
                                    contentItem: Text {
                                        text: parent.text
                                        color: "#111"
                                        font.pixelSize: 13
                                        font.bold: true
                                    }
                                    background: Rectangle {
                                        radius: 8
                                        color: parent.hovered ? accentHover : accentGreen
                                    }
                                    onClicked: backend.openUrl("https://forum.manjaro.org")
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.topMargin: 26
                                Layout.bottomMargin: 22
                                height: 1
                                color: "#22FFFFFF"
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                Repeater {
                                    model: [
                                        { icon: "📚", title: "Manjaro Wiki", desc: "Practical guides for kernels, drivers, and everyday tweaks.", url: "https://wiki.manjaro.org" },
                                        { icon: "🌐", title: "Official Socials", desc: "Follow Manjaro Project e.V. news, releases, and events.", url: "https://manjaro.org" }
                                    ]

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 112
                                        color: cardBg
                                        radius: 12
                                        border.color: commMa.containsMouse ? accentGreen : cardBorder

                                        MouseArea {
                                            id: commMa
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: backend.openUrl(modelData.url)
                                        }

                                        ColumnLayout {
                                            anchors.fill: parent
                                            anchors.margins: 16
                                            spacing: 6
                                            RowLayout {
                                                spacing: 8
                                                Label { text: modelData.icon; font.pixelSize: 18 }
                                                Label { text: modelData.title; color: textPrimary; font.pixelSize: 15; font.bold: true }
                                            }
                                            Label {
                                                Layout.fillWidth: true
                                                text: modelData.desc
                                                color: textMuted
                                                font.pixelSize: 12
                                                wrapMode: Text.WordWrap
                                            }
                                        }
                                    }
                                }
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // ================= CARD 5: CONTRIBUTE & SUPPORT (CENTERED) =================
                    Item {
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 44
                            anchors.rightMargin: 24
                            spacing: 0

                            Item { Layout.fillHeight: true }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 18

                                ColumnLayout {
                                    spacing: 3
                                    Label {
                                        text: "Shape Manjaro's Future"
                                        color: textPrimary
                                        font.pixelSize: 26
                                        font.bold: true
                                    }
                                    Label {
                                        text: "Powered by our community and non-profit foundation."
                                        color: textMuted
                                        font.pixelSize: 13
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 112
                                    radius: 14
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop { position: 0.0; color: "#3335BFA4" }
                                        GradientStop { position: 1.0; color: "#141D242B" }
                                    }
                                    border.color: "#5535BFA4"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 20
                                        spacing: 16

                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 4
                                            Label {
                                                text: "💚 Support the Non-Profit"
                                                color: textPrimary
                                                font.pixelSize: 17
                                                font.bold: true
                                            }
                                            Label {
                                                Layout.fillWidth: true
                                                text: "Donations fund servers, independent development, and open-source advocacy."
                                                color: textMuted
                                                font.pixelSize: 12
                                                wrapMode: Text.WordWrap
                                            }
                                        }

                                        Button {
                                            text: "Donate"
                                            leftPadding: 18; rightPadding: 18; topPadding: 8; bottomPadding: 8
                                            contentItem: Text { text: parent.text; color: "#111"; font.pixelSize: 13; font.bold: true }
                                            background: Rectangle { radius: 8; color: parent.hovered ? accentHover : accentGreen }
                                            onClicked: backend.openUrl("https://manjaro.org/donate")
                                        }
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0

                                    Repeater {
                                        model: [
                                            { icon: "🦊", title: "GitLab Repositories", desc: "Inspect source code, report bugs, or submit pull requests", url: "https://gitlab.manjaro.org" },
                                            { icon: "✉️", title: "Mailing Lists", desc: "Follow development discussions and security notices", url: "https://lists.manjaro.org" },
                                            { icon: "📡", title: "RSS Feeds", desc: "Track stable release announcements in your feed reader", url: "https://forum.manjaro.org/c/announcements.rss" }
                                        ]

                                        Column {
                                            Layout.fillWidth: true
                                            Rectangle {
                                                width: parent.width
                                                height: 62
                                                radius: 8
                                                color: contribMa.containsMouse ? "#14FFFFFF" : "transparent"

                                                MouseArea {
                                                    id: contribMa
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: backend.openUrl(modelData.url)
                                                }

                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.leftMargin: 12
                                                    anchors.rightMargin: 16
                                                    spacing: 14

                                                    Label { text: modelData.icon; font.pixelSize: 22 }
                                                    ColumnLayout {
                                                        Layout.fillWidth: true
                                                        spacing: 1
                                                        Label { text: modelData.title; color: textPrimary; font.pixelSize: 15; font.bold: true }
                                                        Label { text: modelData.desc; color: textMuted; font.pixelSize: 12 }
                                                    }
                                                    Label {
                                                        text: "→"
                                                        color: contribMa.containsMouse ? accentGreen : textMuted
                                                        font.pixelSize: 18
                                                        font.bold: true
                                                    }
                                                }
                                            }
                                            Rectangle {
                                                visible: index < 2
                                                width: parent.width - 24
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                height: 1
                                                color: "#1AFFFFFF"
                                            }
                                        }
                                    }
                                }
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }
                }

                // ================= RIGHT 1/3: FULL-SCALE CROSS-FADING MASCOT STAGE =================
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.34

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 18
                        anchors.bottomMargin: 18
                        width: 1
                        color: "#1AFFFFFF"
                    }

                    Repeater {
                        model: [
                            { img: "../assets/mascot_1.png", quote: "\"Welcome home!\"" },
                            { img: "../assets/mascot_2.png", quote: "\"30 seconds to stay rock-solid.\"" },
                            { img: "../assets/mascot_3.png", quote: "\"Pick only what you need!\"" },
                            { img: "../assets/mascot_4.png", quote: "\"Come say hi on the forum!\"" },
                            { img: "../assets/mascot_5.png", quote: "\"Built together, for everyone.\"" }
                        ]

                        Item {
                            anchors.fill: parent
                            anchors.margins: 16
                            opacity: swipeView.currentIndex === index ? 1.0 : 0.0
                            visible: opacity > 0.01
                            Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.InOutQuad } }

                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 10

                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: 6
                                    color: "#2235BFA4"
                                    border.color: "#4435BFA4"
                                    radius: 14
                                    implicitWidth: Math.min(parent.width - 12, quoteLbl.implicitWidth + 24)
                                    implicitHeight: quoteLbl.implicitHeight + 14

                                    Label {
                                        id: quoteLbl
                                        anchors.centerIn: parent
                                        text: modelData.quote
                                        color: textPrimary
                                        font.pixelSize: 13
                                        font.italic: true
                                    }
                                }

                                Image {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    source: modelData.img
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                }
                            }
                        }
                    }
                }
            }

            // ================= BOTTOM NAVIGATION BAR =================
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 62
                color: "#26000000"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24

                    CheckBox {
                        id: autostartCheck
                        checked: true
                        text: "Launch at start"
                        contentItem: Text {
                            text: autostartCheck.text
                            color: textMuted
                            font.pixelSize: 13
                            leftPadding: autostartCheck.indicator.width + 8
                            verticalAlignment: Text.AlignVCenter
                        }
                        indicator: Rectangle {
                            implicitWidth: 18; implicitHeight: 18
                            x: autostartCheck.leftPadding
                            y: parent.height / 2 - height / 2
                            radius: 4
                            color: autostartCheck.checked ? accentGreen : "transparent"
                            border.color: autostartCheck.checked ? accentGreen : textMuted
                            Text {
                                anchors.centerIn: parent
                                text: "✓"
                                color: "#111"
                                font.pixelSize: 12
                                font.bold: true
                                visible: autostartCheck.checked
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    PageIndicator {
                        count: swipeView.count
                        currentIndex: swipeView.currentIndex
                        interactive: true
                        onCurrentIndexChanged: swipeView.currentIndex = currentIndex

                        delegate: Rectangle {
                            implicitWidth: index === swipeView.currentIndex ? 22 : 8
                            implicitHeight: 8
                            radius: 4
                            color: index === swipeView.currentIndex ? accentGreen : "#44FFFFFF"
                            Behavior on implicitWidth { NumberAnimation { duration: 180 } }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Row {
                        spacing: 10
                        Button {
                            text: "Back"
                            visible: swipeView.currentIndex > 0
                            leftPadding: 18; rightPadding: 18; topPadding: 8; bottomPadding: 8
                            contentItem: Text { text: parent.text; color: textPrimary; font.pixelSize: 13 }
                            background: Rectangle { radius: 8; color: parent.hovered ? "#33FFFFFF" : "#1AFFFFFF" }
                            onClicked: swipeView.currentIndex--
                        }
                        Button {
                            text: swipeView.currentIndex === swipeView.count - 1 ? "Finish" : "Next"
                            leftPadding: 22; rightPadding: 22; topPadding: 8; bottomPadding: 8
                            contentItem: Text { text: parent.text; color: "#111"; font.pixelSize: 13; font.bold: true }
                            background: Rectangle { radius: 8; color: parent.hovered ? accentHover : accentGreen }
                            onClicked: {
                                if (swipeView.currentIndex < swipeView.count - 1) {
                                    swipeView.currentIndex++
                                } else {
                                    Qt.quit()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}