import QtQuick
import QtQuick.Window

Window {
    id: win

    visible: true
    width: 520
    height: 280
    title: "System Stats"
    color: "#3a2a4a"

    // ==================================================
    // Background
    // ==================================================

    Rectangle {
        anchors.fill: parent

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#d99ab8" }
            GradientStop { position: 0.55; color: "#9a6a9c" }
            GradientStop { position: 1.0; color: "#4a3566" }
        }
    }

    Repeater {
        model: [
            { x: 0.12, y: 0.25, s: 220, c: "#ffd1e3", dx: 30, t: 7000 },
            { x: 0.70, y: 0.65, s: 260, c: "#b79cff", dx: -40, t: 9000 },
            { x: 0.45, y: 0.05, s: 160, c: "#ffb3c7", dx: 25, t: 6000 }
        ]

        delegate: Rectangle {
            required property var modelData

            width: modelData.s
            height: modelData.s
            radius: width / 2
            color: modelData.c
            opacity: 0.35

            x: win.width * modelData.x - width / 2
            y: win.height * modelData.y - height / 2

            SequentialAnimation on x {
                loops: Animation.Infinite

                NumberAnimation {
                    to: win.width * modelData.x - width / 2 + modelData.dx
                    duration: modelData.t
                    easing.type: Easing.InOutSine
                }

                NumberAnimation {
                    to: win.width * modelData.x - width / 2 - modelData.dx
                    duration: modelData.t
                    easing.type: Easing.InOutSine
                }
            }
        }
    }

    // ==================================================
    // Ring stat component
    // ==================================================

    component RingStat: Item {
        id: stat

        property string title: "CPU"
        property int value: 18
        property string detail: "Ryzen 5 5600"
        property color accentColor: "#F2A1C6"

        width: 118
        height: 128

        readonly property color textColor: "#FFFFFF"
        readonly property color dimColor: Qt.alpha(textColor, 0.72)
        readonly property color trackColor: Qt.rgba(1, 1, 1, 0.15)
        readonly property string family: Qt.application.font.family

        Item {
            id: ringArea

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 8
            }

            width: 96
            height: 96

            Canvas {
                id: ring
                anchors.fill: parent

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var cx = width / 2
                    var cy = height / 2
                    var radius = 37
                    var lineWidth = 7
                    var start = -Math.PI / 2
                    var end = start + Math.PI * 2 * stat.value / 100

                    ctx.beginPath()
                    ctx.lineWidth = lineWidth
                    ctx.strokeStyle = stat.trackColor
                    ctx.arc(cx, cy, radius, 0, Math.PI * 2)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.lineWidth = lineWidth
                    ctx.lineCap = "round"

                    var gradient = ctx.createLinearGradient(0, 0, width, height)
                    gradient.addColorStop(0, Qt.lighter(stat.accentColor, 1.18))
                    gradient.addColorStop(1, stat.accentColor)

                    ctx.strokeStyle = gradient
                    ctx.arc(cx, cy, radius, start, end)
                    ctx.stroke()
                }

                Connections {
                    target: stat

                    function onValueChanged() {
                        ring.requestPaint()
                    }

                    function onAccentColorChanged() {
                        ring.requestPaint()
                    }
                }
            }

            Column {
                anchors.centerIn: parent
                spacing: 1

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: stat.title
                    color: stat.textColor

                    font {
                        family: stat.family
                        pixelSize: 13
                        weight: Font.DemiBold
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: stat.value + "%"
                    color: stat.textColor

                    font {
                        family: stat.family
                        pixelSize: 16
                        weight: Font.DemiBold
                    }
                }
            }
        }

        // --------------------------------------------------
        // Marquee detail label
        // --------------------------------------------------

        Item {
            id: detailArea

            anchors {
                horizontalCenter: parent.horizontalCenter
                top: ringArea.bottom
                topMargin: 0
            }

            width: 90
            height: 18
            clip: true

            Text {
                id: detailText

                y: (detailArea.height - height) / 2

                text: stat.detail
                color: stat.dimColor

                font {
                    family: stat.family
                    pixelSize: 11
                    weight: Font.Medium
                }

                x: width <= detailArea.width
                    ? (detailArea.width - width) / 2
                    : 0

                SequentialAnimation on x {
                    running: detailText.width > detailArea.width
                    loops: Animation.Infinite

                    PauseAnimation {
                        duration: 1000
                    }

                    NumberAnimation {
                        to: detailArea.width - detailText.width
                        duration: 4000
                        easing.type: Easing.InOutSine
                    }

                    PauseAnimation {
                        duration: 1000
                    }

                    NumberAnimation {
                        to: 0
                        duration: 4000
                        easing.type: Easing.InOutSine
                    }
                }
            }
        }
    }

    // ==================================================
    // Main card
    // ==================================================

    Item {
        id: card

        anchors.centerIn: parent

        property int paddingX: 18
        property int paddingY: 6

        implicitWidth: content.implicitWidth + paddingX * 2
        implicitHeight: content.implicitHeight + paddingY * 2

        width: implicitWidth
        height: implicitHeight + 10

        property color glassColor: Qt.rgba(1, 1, 1, 0.09)
        property color borderColor: Qt.rgba(1, 1, 1, 0.16)
        property real cornerRadius: 24
        property real rimStrength: 0.20
        property int rimSize: 4

        scale: hover.hovered ? 1.02 : 1.0

        Behavior on scale {
            SpringAnimation {
                spring: 3
                damping: 0.28
                epsilon: 0.001
            }
        }

        HoverHandler {
            id: hover
        }

        Rectangle {
            anchors.fill: parent
            radius: card.cornerRadius
            color: card.glassColor
            border.width: 1
            border.color: card.borderColor

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: parent.radius - 1

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.07) }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.01) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.03) }
                }
            }

            Repeater {
                model: card.rimSize

                delegate: Rectangle {
                    required property int index

                    anchors.fill: parent
                    anchors.margins: 1 + index
                    radius: Math.max(0, card.cornerRadius - 1 - index)

                    color: "transparent"
                    border.width: 1

                    border.color: Qt.rgba(
                        1,
                        1,
                        1,
                        card.rimStrength * Math.pow(1 - index / card.rimSize, 2)
                    )
                }
            }

            Rectangle {
                id: sheen

                property real p: 0

                anchors.fill: parent
                anchors.margins: 1
                radius: parent.radius - 1

                gradient: Gradient {
                    orientation: Gradient.Horizontal

                    GradientStop {
                        position: 0.0
                        color: "transparent"
                    }

                    GradientStop {
                        position: Math.max(0.01, Math.min(0.99, sheen.p))
                        color: Qt.rgba(
                            1,
                            1,
                            1,
                            0.12 * Math.sin(Math.PI * sheen.p)
                        )
                    }

                    GradientStop {
                        position: 1.0
                        color: "transparent"
                    }
                }

                SequentialAnimation on p {
                    loops: Animation.Infinite

                    PauseAnimation {
                        duration: 5000
                    }

                    NumberAnimation {
                        from: 0
                        to: 1
                        duration: 1800
                        easing.type: Easing.InOutSine
                    }
                }
            }
        }

        // ==================================================
        // Content
        // ==================================================

        Row {
            id: content

            x: card.paddingX
            y: card.paddingY
            spacing: 18

            RingStat {
                title: "CPU"
                value: 18
                detail: "Ryzen 5 5600 hello-world"
                accentColor: "#F2A1C6"
            }

            RingStat {
                title: "RAM"
                value: 42
                detail: "32GB"
                accentColor: "#B675FF"
            }

            RingStat {
                title: "Disk"
                value: 19
                detail: "128/512GB"
                accentColor: "#6CC7FF"
            }
        }
    }
}
