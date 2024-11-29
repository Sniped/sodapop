import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Components"

Item {
    ColumnLayout {
        anchors.centerIn: parent
        spacing: -60

        Image {
            id: arrow1
            source: "../Icons/arrow.svg"
            Layout.preferredWidth: 90
            Layout.preferredHeight: 90
            fillMode: Image.PreserveAspectFit
            rotation: 90 // Rotate arrow 90 degrees
            opacity: 0.2

            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                NumberAnimation {
                    target: arrow1
                    property: "opacity"
                    to: 1
                    duration: 300
                }
                NumberAnimation {
                    target: arrow1
                    property: "opacity"
                    to: 0.2
                    duration: 300
                }
                PauseAnimation {
                    duration: 1200
                }
            }
        }

        Image {
            id: arrow2
            source: "../Icons/arrow.svg"
            Layout.preferredWidth: 90
            Layout.preferredHeight: 90
            fillMode: Image.PreserveAspectFit
            rotation: 90
            opacity: 0.2

            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                PauseAnimation {
                    duration: 300
                }
                NumberAnimation {
                    target: arrow2
                    property: "opacity"
                    to: 1
                    duration: 300
                }
                NumberAnimation {
                    target: arrow2
                    property: "opacity"
                    to: 0.2
                    duration: 300
                }
                PauseAnimation {
                    duration: 900
                }
            }
        }

        Image {
            id: arrow3
            source: "../Icons/arrow.svg"
            Layout.preferredWidth: 90
            Layout.preferredHeight: 90
            fillMode: Image.PreserveAspectFit
            rotation: 90
            opacity: 0.2

            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                PauseAnimation {
                    duration: 600
                }
                NumberAnimation {
                    target: arrow3
                    property: "opacity"
                    to: 1
                    duration: 300
                }
                NumberAnimation {
                    target: arrow3
                    property: "opacity"
                    to: 0.2
                    duration: 300
                }
                PauseAnimation {
                    duration: 600
                }
            }
        }

        Image {
            id: arrow4
            source: "../Icons/arrow.svg"
            Layout.preferredWidth: 90
            Layout.preferredHeight: 90
            fillMode: Image.PreserveAspectFit
            rotation: 90
            opacity: 0.2

            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                PauseAnimation {
                    duration: 900
                }
                NumberAnimation {
                    target: arrow4
                    property: "opacity"
                    to: 1
                    duration: 300
                }
                NumberAnimation {
                    target: arrow4
                    property: "opacity"
                    to: 0.2
                    duration: 300
                }
                PauseAnimation {
                    duration: 300
                }
            }
        }

        Image {
            id: arrow5
            source: "../Icons/arrow.svg"
            Layout.preferredWidth: 90
            Layout.preferredHeight: 90
            fillMode: Image.PreserveAspectFit
            rotation: 90
            opacity: 0.2

            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                PauseAnimation {
                    duration: 1200
                }
                NumberAnimation {
                    target: arrow5
                    property: "opacity"
                    to: 1
                    duration: 300
                }
                NumberAnimation {
                    target: arrow5
                    property: "opacity"
                    to: 0.2
                    duration: 300
                }
            }
        }
    }
}
