import QtQuick
import QtQuick.Layouts

Rectangle {
    width: parent.width
    height: parent.height
    color: "#111827"
    radius: 12
    property string title: ""
    property var sensorModel: ListModel {}

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Text {
            text: title
            color: "white"
            font.pixelSize: 20
            font.bold: true
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            columnSpacing: 12
            rowSpacing: 12

            Repeater {
                model: sensorModel
                delegate: SensorValue {
                    Layout.fillWidth: true
                    label: model.label
                    value: model.value
                    unit: model.unit
                }
            }
        }
    }
}
