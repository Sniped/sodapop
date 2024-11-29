// src/qml/Components/NavButton.qml
import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 40
    height: 40
    radius: 8

    property bool active: false
    property string iconSource
    property string pageName: "" // Added property for page name

    signal clicked

    // Gradient background
    gradient: Gradient {
        id: buttonGradient
        GradientStop {
            id: gradientStart
            position: 0.0
            color: active ? "#2a69ed" : (mouseArea.containsMouse ? "#3B82F6" : "transparent")
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
        GradientStop {
            id: gradientEnd
            position: 1.0
            color: active ? "#5da1f9" : (mouseArea.containsMouse ? "#60A5FA" : "transparent")
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }

    Image {
        anchors.centerIn: parent
        width: 24
        height: 24
        source: parent.iconSource
        fillMode: Image.PreserveAspectFit
        opacity: active || mouseArea.containsMouse ? 1.0 : 0.7

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
        onEntered: hoverTimer.start()
        onExited: {
            hoverTimer.stop()
            pageNamePopup.close()
        }
    }

    Timer {
        id: hoverTimer
        interval: 500 // Show popup after 500ms hover
        repeat: false
        onTriggered: {
            if (mouseArea.containsMouse) {
                pageNamePopup.open()
            }
        }
    }

    Popup {
        id: pageNamePopup
        x: root.width + 5 // Position popup to the right of the button
        y: (root.height - height) / 2
        padding: 8
        background: Rectangle {
            color: "#1F2937"
            radius: 6
            border.color: "#374151"
            border.width: 1
        }

        contentItem: Text {
            text: pageName
            color: "white"
            font.pixelSize: 14
        }

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 100
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 100
            }
        }
    }
}
