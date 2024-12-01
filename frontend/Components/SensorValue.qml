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
    property int numElements: 0

    Text {
        id: title
        anchors {
            top: parent.top
            left: parent.left
            margins: 12
        }
        text: label
        color: "#94A3B8"
        font.pixelSize: numElements === 2 ? Math.min(
                                                parent.width * 0.052,
                                                parent.height * 0.225) : Math.min(
                                                parent.width * 0.1,
                                                parent.height * 0.35)
    }

    Row {
        anchors.centerIn: parent
        spacing: -6

        Text {
            text: value + " "
            color: "#60A5FA"
            font.pixelSize: numElements === 2 ? Math.min(
                                                    parent.parent.width * 0.105,
                                                    parent.parent.height * 0.425) : Math.min(
                                                    parent.parent.width * 0.18,
                                                    parent.parent.height * 0.65)
            font.bold: true
        }
        Text {
            text: unit
            color: "#94A3B8"
            font.pixelSize: numElements === 2 ? Math.min(
                                                    parent.parent.width * 0.052,
                                                    parent.parent.height * 0.225) : Math.min(
                                                    parent.parent.width * 0.1,
                                                    parent.parent.height * 0.35)
            anchors.baseline: parent.children[0].baseline
            wrapMode: Text.WordWrap
        }
    }
}
