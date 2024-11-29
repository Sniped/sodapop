import QtQuick
import QtQuick.Layouts

Rectangle {
    width: parent.width
    height: 80
    color: "#1E293B"
    radius: 8
    property string label: ""
    property string value: ""
    property string unit: ""

    Text {
        id: title
        anchors {
            top: parent.top
            left: parent.left
            margins: 12
        }
        text: label
        color: "#94A3B8"
        font.pixelSize: 20
        width: parent.width - 16
        wrapMode: Text.Wrap
    }

    Row {
        anchors.centerIn: parent
        spacing: -6

        Text {
            text: value + " "
            color: "#60A5FA"
            font.pixelSize: 42
            font.bold: true
        }
        Text {
            text: unit
            color: "#94A3B8"
            font.pixelSize: 20
            anchors.baseline: parent.children[0].baseline
            wrapMode: Text.WordWrap
        }
    }
}
