import QtQuick
import QtQuick.Layouts

Rectangle {
    width: parent.width
    height: parent.height
    color: "#111827"
    radius: 12
    property string title: ""
    property var sensorModel: ListModel {}

    Item {
        anchors.fill: parent
        anchors.margins: 16

        Text {
            id: machineTitle
            text: title
            color: "white"
            font.pixelSize: 35
            font.bold: true
        }

        GridLayout {
            id: sensorGrid
            anchors {
                top: machineTitle.bottom
                topMargin: 16
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            columns: 2
            columnSpacing: 12
            rowSpacing: 12

            Repeater {
                model: sensorModel
                delegate: SensorValue {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.columnSpan: sensorModel.count === 2 ? 2 : 1
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: sensorModel.count === 2 ? sensorGrid.height / 2 : 1
                    label: model.label
                    value: model.value
                    unit: model.unit
                    numElements: sensorModel.count
                }
            }
        }
    }
}
