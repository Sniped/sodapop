// LogsPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtAthon.Models 1.0

Page {
    background: Rectangle {
        color: "black"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Text {
            text: "System Logs"
            color: "white"
            font.pixelSize: 24
            font.bold: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#111827"
            radius: 12

            ListView {
                id: logsView
                anchors.fill: parent
                anchors.margins: 16
                clip: true
                spacing: 8
                model: LogsModel {}

                delegate: Rectangle {
                    width: logsView.width
                    height: 60
                    color: "#1F2937"
                    radius: 6

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Text {
                            text: model.timestamp
                            color: "#9CA3AF"
                            font.pixelSize: 14
                        }

                        Text {
                            text: model.type
                            color: model.type === "ERROR" ? "#FCA5A5" : "#FCD34D"
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Text {
                            text: model.message
                            color: "white"
                            font.pixelSize: 14
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {}
            }
        }
    }
}
