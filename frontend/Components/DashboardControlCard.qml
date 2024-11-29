import QtQuick
import QtQuick.Layouts

Rectangle {
    width: parent.width
    height: parent.height
    color: "#111827"
    radius: 12
    id: root

    Text {
        id: title
        text: "Sodapop Co"
        color: "white"
        font.pixelSize: 50
        font.bold: true
        anchors {
            left: parent.left
            leftMargin: 16
        }
    }

    Rectangle {
        id: statusIndicator
        width: 135
        height: 42
        radius: 24
        anchors {
            right: parent.right
            rightMargin: 16
            top: parent.top
            topMargin: 20
        }
        color: controlButton.running ? "#059669" : "#991B1B"

        Row {
            anchors.centerIn: parent
            spacing: 8

            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: "white"
                anchors.verticalCenter: parent.verticalCenter

                SequentialAnimation on opacity {
                    running: controlButton.running
                    loops: Animation.Infinite
                    PropertyAnimation {
                        to: 0.3
                        duration: 1000
                    }
                    PropertyAnimation {
                        to: 1.0
                        duration: 1000
                    }
                }
            }

            Text {
                text: controlButton.running ? "RUNNING" : "STOPPED"
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }

    // Divider
    Rectangle {
        id: divider
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 16
            rightMargin: 16
            top: title.bottom
            topMargin: 12
        }
        height: 2
        color: "#1F2937"
    }

    // Metrics Grid
    GridLayout {
        id: metricsGrid
        anchors {
            top: divider.bottom
            bottom: controlButton.top
            left: parent.left
            right: parent.right
            margins: 16
            bottomMargin: 24
        }
        columns: 3
        columnSpacing: 16
        rowSpacing: 16

        // Batch Info (Moved to first position)
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1E293B"
            radius: 8

            Column {
                anchors.fill: parent
                anchors.margins: 16

                Text {
                    text: "Batch Info"
                    color: "#94A3B8"
                    font.pixelSize: 20
                    width: parent.width
                    wrapMode: Text.Wrap
                    height: contentHeight
                }

                Item {
                    width: parent.width
                    height: parent.height - parent.children[0].height - 16

                    Column {
                        anchors.centerIn: parent
                        width: parent.width
                        spacing: 4

                        Text {
                            text: "Batch #4528"
                            color: "#94A3B8"
                            font.pixelSize: 24
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            text: "Cola Classic"
                            color: "#60A5FA"
                            font.pixelSize: 24
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }

        // Production Status
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1E293B"
            radius: 8

            Column {
                anchors.fill: parent
                anchors.margins: 16

                Text {
                    text: "Production Status"
                    color: "#94A3B8"
                    font.pixelSize: 20
                    width: parent.width
                    wrapMode: Text.Wrap
                    height: contentHeight
                }

                Item {
                    width: parent.width
                    height: parent.height - parent.children[0].height - 16

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: "120"
                            color: "#60A5FA"
                            font.pixelSize: 42
                            font.bold: true
                        }
                        Text {
                            text: "bottles/min"
                            color: "#94A3B8"
                            font.pixelSize: 16
                            anchors.baseline: parent.children[0].baseline
                            wrapMode: Text.WordWrap
                            width: contentWidth
                        }
                    }
                }
            }
        }

        // Daily Target
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1E293B"
            radius: 8

            Column {
                anchors.fill: parent
                anchors.margins: 16

                Text {
                    text: "Daily Target (Boxes)"
                    color: "#94A3B8"
                    font.pixelSize: 20
                    width: parent.width
                    wrapMode: Text.Wrap
                    height: contentHeight
                }

                Item {
                    width: parent.width
                    height: parent.height - parent.children[0].height - 16

                    Column {
                        anchors.centerIn: parent
                        width: parent.width
                        spacing: 12

                        Rectangle {
                            width: parent.width
                            height: 12
                            color: "#0F172A"
                            radius: 6

                            Rectangle {
                                width: parent.width * (1250 / 5000)
                                height: parent.height
                                color: "#60A5FA"
                                radius: 6
                            }
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "1,250" + " / " + "5,000"
                            color: "#60A5FA"
                            font.pixelSize: 16
                        }
                    }
                }
            }
        }

        // OEE Metric (Moved to fourth position)
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1E293B"
            radius: 8

            Column {
                anchors.fill: parent
                anchors.margins: 16

                Text {
                    text: "OEE"
                    color: "#94A3B8"
                    font.pixelSize: 20
                    width: parent.width
                    wrapMode: Text.Wrap
                    height: contentHeight
                }

                Item {
                    width: parent.width
                    height: parent.height - parent.children[0].height - 16

                    Text {
                        text: "87.5%"
                        color: "#60A5FA"
                        font.pixelSize: 42
                        font.bold: true
                        anchors.centerIn: parent
                    }
                }
            }
        }

        // Downtime Today
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1E293B"
            radius: 8

            Column {
                anchors.fill: parent
                anchors.margins: 16

                Text {
                    text: "Downtime Today"
                    color: "#94A3B8"
                    font.pixelSize: 20
                    width: parent.width
                    wrapMode: Text.Wrap
                    height: contentHeight
                }

                Item {
                    width: parent.width
                    height: parent.height - parent.children[0].height - 16

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: "23"
                            color: "#60A5FA"
                            font.pixelSize: 42
                            font.bold: true
                        }
                        Text {
                            text: "minutes"
                            color: "#94A3B8"
                            font.pixelSize: 16
                            anchors.baseline: parent.children[0].baseline
                            wrapMode: Text.WordWrap
                            width: contentWidth
                        }
                    }
                }
            }
        }

        // Boxes Packed Today
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1E293B"
            radius: 8

            Column {
                anchors.fill: parent
                anchors.margins: 16

                Text {
                    text: "Boxes Packed Today"
                    color: "#94A3B8"
                    font.pixelSize: 20
                    width: parent.width
                    wrapMode: Text.Wrap
                    height: contentHeight
                }

                Item {
                    width: parent.width
                    height: parent.height - parent.children[0].height - 16

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: "1,250"
                            color: "#60A5FA"
                            font.pixelSize: 42
                            font.bold: true
                        }
                        Text {
                            text: "boxes"
                            color: "#94A3B8"
                            font.pixelSize: 16
                            anchors.baseline: parent.children[0].baseline
                            wrapMode: Text.WordWrap
                            width: contentWidth
                        }
                    }
                }
            }
        }
    }

    // Start/Stop Button
    Rectangle {
        id: controlButton
        anchors {
            bottom: parent.bottom
            bottomMargin: 16
            left: parent.left
            right: parent.right
            leftMargin: 16
            rightMargin: 16
        }
        height: 64
        radius: 8
        color: buttonMouseArea.pressed ? (running ? "#991B1B" : "#065F46") : (running ? "#DC2626" : "#059669")
        property bool running: false

        Text {
            anchors.centerIn: parent
            text: parent.running ? "STOP" : "START"
            color: "white"
            font.pixelSize: 18
            font.bold: true
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 2
            border.color: parent.running ? "#FECACA" : "#A7F3D0"
            opacity: 0.5
        }

        MouseArea {
            id: buttonMouseArea
            anchors.fill: parent
            onClicked: {
                controlButton.running = !controlButton.running
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }
}
