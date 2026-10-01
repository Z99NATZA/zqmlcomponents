import QtQuick
import QtQuick.Window

Window {
    id: win

    visible: true
    width: 520
    height: 340

    title: "App Launcher"
    color: "#3a2a4a"

    // ==================================================
    // Background
    // Same tone as ClockWeatherCard
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

    // ==================================================
    // Moving background circles
    // ==================================================

    Repeater {
        model: [
            {
                x: 0.12,
                y: 0.25,
                s: 220,
                c: "#ffd1e3",
                dx: 30,
                t: 7000
            },
            {
                x: 0.70,
                y: 0.65,
                s: 260,
                c: "#b79cff",
                dx: -40,
                t: 9000
            },
            {
                x: 0.45,
                y: 0.05,
                s: 160,
                c: "#ffb3c7",
                dx: 25,
                t: 6000
            }
        ]

        delegate: Rectangle {
            required property var modelData

            width: modelData.s
            height: modelData.s

            radius: width / 2

            color: modelData.c
            opacity: 0.35

            x:
                win.width * modelData.x
                - width / 2

            y:
                win.height * modelData.y
                - height / 2

            SequentialAnimation on x {
                loops: Animation.Infinite

                NumberAnimation {
                    to:
                        win.width * modelData.x
                        - width / 2
                        + modelData.dx

                    duration:
                        modelData.t

                    easing.type:
                        Easing.InOutSine
                }

                NumberAnimation {
                    to:
                        win.width * modelData.x
                        - width / 2
                        - modelData.dx

                    duration:
                        modelData.t

                    easing.type:
                        Easing.InOutSine
                }
            }
        }
    }

    // ==================================================
    // App Launcher Card
    // ==================================================

    Item {
        id: card

        anchors.centerIn: parent

        width: 420
        height: 245

        // --------------------------------------------------
        // Style
        // Same values as ClockWeatherCard
        // --------------------------------------------------

        property color textColor:
            "#FFFFFF"

        property color glassColor:
            Qt.rgba(1, 1, 1, 0.09)

        property color borderColor:
            Qt.rgba(1, 1, 1, 0.16)

        property color accentColor:
            "#F3A5CD"

        property color dimColor:
            Qt.alpha(textColor, 0.75)

        property real cornerRadius:
            26

        property real rimStrength:
            0.20

        property int rimSize:
            4

        readonly property string family:
            Qt.application.font.family

        // ==================================================
        // Intro animation
        // Same feeling as ClockWeatherCard
        // ==================================================

        opacity: 0

        transform: Translate {
            id: enterTransform
            y: 14
        }

        NumberAnimation on opacity {
            from: 0
            to: 1

            duration: 600

            easing.type:
                Easing.OutCubic
        }

        NumberAnimation {
            target: enterTransform
            property: "y"

            from: 14
            to: 0

            duration: 700

            easing.type:
                Easing.OutCubic

            running: true
        }

        // ==================================================
        // Card hover
        // ==================================================

        scale:
            cardHover.hovered
                ? 1.025
                : 1.0

        Behavior on scale {
            SpringAnimation {
                spring: 3
                damping: 0.28
                epsilon: 0.001
            }
        }

        HoverHandler {
            id: cardHover
        }

        // ==================================================
        // Glass body
        // ==================================================

        Rectangle {
            anchors.fill: parent

            radius:
                card.cornerRadius

            color:
                card.glassColor

            border.width:
                1

            border.color:
                card.borderColor

            // --------------------------------------------------
            // Glass soft gradient
            // --------------------------------------------------

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1

                radius:
                    parent.radius - 1

                gradient: Gradient {
                    GradientStop {
                        position: 0.0

                        color:
                            Qt.rgba(
                                1,
                                1,
                                1,
                                0.07
                            )
                    }

                    GradientStop {
                        position: 0.50

                        color:
                            Qt.rgba(
                                1,
                                1,
                                1,
                                0.01
                            )
                    }

                    GradientStop {
                        position: 1.0

                        color:
                            Qt.rgba(
                                1,
                                1,
                                1,
                                0.03
                            )
                    }
                }
            }

            // --------------------------------------------------
            // Inner rim
            // --------------------------------------------------

            Repeater {
                model:
                    card.rimSize

                delegate: Rectangle {
                    required property int index

                    anchors.fill:
                        parent

                    anchors.margins:
                        1 + index

                    radius:
                        Math.max(
                            0,
                            card.cornerRadius
                                - 1
                                - index
                        )

                    color:
                        "transparent"

                    border.width:
                        1

                    border.color:
                        Qt.rgba(
                            1,
                            1,
                            1,
                            card.rimStrength
                                * Math.pow(
                                    1
                                        - index
                                        / card.rimSize,
                                    2
                                )
                        )
                }
            }

            // --------------------------------------------------
            // Moving sheen
            // --------------------------------------------------

            Rectangle {
                id: sheen

                property real p:
                    0

                anchors.fill:
                    parent

                anchors.margins:
                    1

                radius:
                    parent.radius - 1

                gradient: Gradient {
                    orientation:
                        Gradient.Horizontal

                    GradientStop {
                        position: 0.0

                        color:
                            "transparent"
                    }

                    GradientStop {
                        position:
                            Math.max(
                                0.01,
                                Math.min(
                                    0.99,
                                    sheen.p
                                )
                            )

                        color:
                            Qt.rgba(
                                1,
                                1,
                                1,
                                0.12
                                    * Math.sin(
                                        Math.PI
                                            * sheen.p
                                    )
                            )
                    }

                    GradientStop {
                        position: 1.0

                        color:
                            "transparent"
                    }
                }

                SequentialAnimation on p {
                    loops:
                        Animation.Infinite

                    PauseAnimation {
                        duration:
                            5000
                    }

                    NumberAnimation {
                        from: 0
                        to: 1

                        duration:
                            1800

                        easing.type:
                            Easing.InOutSine
                    }
                }
            }
        }

        // ==================================================
        // Apps
        // ==================================================

        Grid {
            id: appGrid

            anchors.centerIn:
                parent

            columns:
                4

            columnSpacing:
                22

            rowSpacing:
                14

            LauncherApp {
                name: "Code"
            }

            LauncherApp {
                name: "Browser"
            }

            LauncherApp {
                name: "Terminal"
            }

            LauncherApp {
                name: "Files"
            }

            LauncherApp {
                name: "Docker"
            }

            LauncherApp {
                name: "Git"
            }

            LauncherApp {
                name: "Music"
            }

            LauncherApp {
                name: "Settings"
            }
        }
    }

    // ==================================================
    // App component
    // ==================================================

    component LauncherApp: Item {
        id: app

        property string name:
            "App"

        width:
            76

        height:
            88

        // --------------------------------------------------
        // Hover
        //
        // Only scale.
        // Do NOT change y because Grid position should stay
        // stable.
        // --------------------------------------------------

        scale:
            appHover.hovered
                ? 1.045
                : 1.0

        Behavior on scale {
            SpringAnimation {
                spring: 3
                damping: 0.28
                epsilon: 0.001
            }
        }

        // ==================================================
        // Icon
        // ==================================================

        Item {
            id: iconWrap

            anchors {
                horizontalCenter:
                    parent.horizontalCenter

                top:
                    parent.top

                topMargin:
                    5
            }

            width:
                52

            height:
                52

            // ----------------------------------------------
            // Icon background
            // ----------------------------------------------

            Rectangle {
                anchors.fill:
                    parent

                radius:
                    13

                color:
                    card.accentColor

                border.width:
                    1

                border.color:
                    Qt.rgba(
                        1,
                        1,
                        1,
                        0.12
                    )

                // subtle icon gradient

                Rectangle {
                    anchors.fill:
                        parent

                    anchors.margins:
                        1

                    radius:
                        parent.radius - 1

                    gradient: Gradient {
                        GradientStop {
                            position:
                                0.0

                            color:
                                Qt.rgba(
                                    1,
                                    1,
                                    1,
                                    0.14
                                )
                        }

                        GradientStop {
                            position:
                                0.5

                            color:
                                Qt.rgba(
                                    1,
                                    1,
                                    1,
                                    0.02
                                )
                        }

                        GradientStop {
                            position:
                                1.0

                            color:
                                Qt.rgba(
                                    1,
                                    1,
                                    1,
                                    0.04
                                )
                        }
                    }
                }

                // soft hover glow

                Rectangle {
                    anchors.fill:
                        parent

                    radius:
                        parent.radius

                    color:
                        Qt.rgba(
                            1,
                            1,
                            1,
                            appHover.hovered
                                ? 0.08
                                : 0.0
                        )

                    Behavior on color {
                        ColorAnimation {
                            duration: 160
                        }
                    }
                }
            }

            // ==================================================
            // Placeholder glyph
            // ==================================================

            Item {
                anchors.centerIn:
                    parent

                width:
                    26

                height:
                    23

                // body

                Rectangle {
                    x: 1
                    y: 5

                    width:
                        24

                    height:
                        17

                    radius:
                        5

                    color:
                        Qt.rgba(
                            1,
                            1,
                            1,
                            0.30
                        )
                }

                // top tab

                Rectangle {
                    x: 5
                    y: 2

                    width:
                        10

                    height:
                        6

                    radius:
                        3

                    color:
                        Qt.rgba(
                            1,
                            1,
                            1,
                            0.55
                        )
                }

                // line 1

                Rectangle {
                    x: 6
                    y: 10

                    width:
                        13

                    height:
                        2

                    radius:
                        1

                    color:
                        Qt.rgba(
                            1,
                            1,
                            1,
                            0.78
                        )
                }

                // line 2

                Rectangle {
                    x: 6
                    y: 14

                    width:
                        10

                    height:
                        2

                    radius:
                        1

                    color:
                        Qt.rgba(
                            1,
                            1,
                            1,
                            0.48
                        )
                }
            }
        }

        // ==================================================
        // App name
        // ==================================================

        Text {
            anchors {
                horizontalCenter:
                    parent.horizontalCenter

                top:
                    iconWrap.bottom

                topMargin:
                    7
            }

            width:
                parent.width

            horizontalAlignment:
                Text.AlignHCenter

            text:
                app.name

            color:
                card.textColor

            opacity:
                appHover.hovered
                    ? 1.0
                    : 0.90

            Behavior on opacity {
                NumberAnimation {
                    duration:
                        150
                }
            }

            elide:
                Text.ElideRight

            font {
                family:
                    card.family

                pixelSize:
                    13

                weight:
                    Font.Medium
            }
        }

        HoverHandler {
            id: appHover
        }

        MouseArea {
            anchors.fill:
                parent

            cursorShape:
                Qt.PointingHandCursor
        }
    }
}
