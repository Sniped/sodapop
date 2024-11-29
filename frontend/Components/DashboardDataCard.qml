import QtQuick
import QtQuick.Layouts

Rectangle {
    width: parent.width
    height: parent.height
    color: "#111827"
    radius: 12

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Text {
            text: "Data"
            color: "white"
            font.pixelSize: 50
            font.bold: true
        }
    }
}
