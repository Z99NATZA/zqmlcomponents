import QtQuick
import QtQuick.Window

Window {
    id: win

    visible: true
    width: 760
    height: 200

    title: "Horizontal Dock"
    color: "#2f3040"

    // ==================================================
    // Background
    // ==================================================

    Rectangle {
        anchors.fill: parent

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "#d99ab8"
            }

            GradientStop {
                position: 0.55
                color: "#9a6a9c"
            }

            GradientStop {
                position: 1.0
                color: "#4a3566"
            }
        }
    }

    Repeater {
        model: [
            { x: 0.10, y: 0.18, s: 230, c: "#ffd1e3" },
            { x: 0.80, y: 0.62, s: 270, c: "#b79cff" },
            { x: 0.48, y: 0.00, s: 165, c: "#ffb3c7" }
        ]

        delegate: Rectangle {
            required property var modelData

            width: modelData.s
            height: modelData.s
            radius: width / 2

            color: modelData.c
            opacity: 0.30

            x: win.width * modelData.x - width / 2
            y: win.height * modelData.y - height / 2
        }
    }

    // ==================================================
    // Dock
    // ==================================================

    Item {
        id: dock

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 26
        }

        width: 560
        height: 72

        property color glassColor:
            Qt.rgba(0.12, 0.08, 0.15, 0.58)

        property color borderColor:
            Qt.rgba(1, 1, 1, 0.18)

        property real cornerRadius: 22

        // ==================================================
        // Glass body
        // ==================================================

        Rectangle {
            anchors.fill: parent

            radius: dock.cornerRadius

            color: dock.glassColor

            border.width: 1
            border.color: dock.borderColor

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1

                radius: parent.radius - 1

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(1, 1, 1, 0.065)
                    }

                    GradientStop {
                        position: 0.45
                        color: Qt.rgba(1, 1, 1, 0.01)
                    }

                    GradientStop {
                        position: 1.0
                        color: Qt.rgba(1, 1, 1, 0.02)
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 2

                radius: parent.radius - 2

                color: "transparent"

                border.width: 1
                border.color:
                    Qt.rgba(1, 1, 1, 0.055)
            }
        }

        // ==================================================
        // Apps
        // ==================================================

        Row {
            id: appRow

            anchors.centerIn: parent

            spacing: 18

            Repeater {
                model: 7

                delegate: DockIcon { }
            }

            LauncherIcon { }
        }
    }

    // ==================================================
    // Reusable Placeholder App
    // ==================================================

    component DockIcon: Item {
        id: icon

        width: 48
        height: 48

        scale:
            hover.hovered
                ? 1.10
                : 1.0

        y:
            hover.hovered
                ? -4
                : 0

        Behavior on scale {
            SpringAnimation {
                spring: 3
                damping: 0.28
            }
        }

        Behavior on y {
            SpringAnimation {
                spring: 3
                damping: 0.28
            }
        }

        // ==================================================
        // Placeholder folder icon
        // ==================================================

        Item {
            anchors.centerIn: parent

            width: 38
            height: 32

            // folder tab
            Rectangle {
                x: 4
                y: 1

                width: 17
                height: 8

                radius: 4

                color:
                    "#F6ADB2"
            }

            // folder body
            Rectangle {
                x: 2
                y: 7

                width: 36
                height: 24

                radius: 7

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: "#FFC0C0"
                    }

                    GradientStop {
                        position: 1.0
                        color: "#EF858C"
                    }
                }
            }

            // highlight
            Rectangle {
                x: 5
                y: 10

                width: 30
                height: 2

                radius: 1

                color:
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.14
                    )
            }
        }

        HoverHandler {
            id: hover
        }

        MouseArea {
            anchors.fill: parent

            cursorShape:
                Qt.PointingHandCursor
        }
    }

    // ==================================================
    // Launcher — similar to bottom icon in ref
    // ==================================================

    component LauncherIcon: Item {
        id: launcher

        width: 48
        height: 48

        scale:
            launcherHover.hovered
                ? 1.08
                : 1.0

        y:
            launcherHover.hovered
                ? -3
                : 0

        Behavior on scale {
            SpringAnimation {
                spring: 3
                damping: 0.28
            }
        }

        Behavior on y {
            SpringAnimation {
                spring: 3
                damping: 0.28
            }
        }

Grid {
    anchors.centerIn: parent

    columns: 2
    spacing: 5

    Repeater {
        model: 4

        delegate: Rectangle {
            width: 11
            height: 11

            radius: 3.5

            color:
                Qt.rgba(
                    1,
                    1,
                    1,
                    0.82
                )

            border.width: 1

            border.color:
                Qt.rgba(
                    1,
                    1,
                    1,
                    0.14
                )
        }
    }
}

        HoverHandler {
            id: launcherHover
        }

        MouseArea {
            anchors.fill: parent

            cursorShape:
                Qt.PointingHandCursor
        }
    }
}
