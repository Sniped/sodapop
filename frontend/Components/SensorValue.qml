import QtQuick
import QtQuick.Layouts

Rectangle {
    width: parent.width
    height: 80
    color: "#1F2937"
    radius: 8
    property string label: ""
    property string value: ""
    property string unit: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 4

        Text {
            text: label
            color: "#9CA3AF"
            font.pixelSize: 14
        }

        Text {
            text: value + " " + unit
            color: "#60A5FA"
            font.pixelSize: 24
            font.bold: true
        }
    }
}
