import QtQuick
import QtQuick.Window

Window {
    visible: true
    width: 500
    height: 220

    color: "#3a2a4a"
    title: "Cava Visualizer"

    Rectangle {
        anchors.fill: parent

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#d99ab8" }
            GradientStop { position: 0.55; color: "#9a6a9c" }
            GradientStop { position: 1.0; color: "#4a3566" }
        }
    }

    Item {
        id: visualizer

        anchors.centerIn: parent

        width: 380
        height: 100

        property color barColor: "#F3A5CD"

        Row {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            spacing: 7

            Repeater {
                model: 24

                delegate: Item {
                    required property int index

                    width: 9
                    height: visualizer.height

                    Rectangle {
                        id: bar

                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                        }

                        width: 9

                        height:
                            18
                            + Math.abs(
                                Math.sin(
                                    index * 0.7
                                    + phase.value
                                )
                            ) * 72

                        radius: width / 2

                        color:
                            visualizer.barColor
                    }
                }
            }
        }

        NumberAnimation {
            id: phase

            property real value: 0

            target: phase
            property: "value"

            from: 0
            to: Math.PI * 2

            duration: 1600

            loops: Animation.Infinite

            running: true
        }
    }
}
