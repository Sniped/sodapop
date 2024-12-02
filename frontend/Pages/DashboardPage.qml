// DashboardPage.qml


/*
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Components"

Page {
    background: Rectangle {
        color: "black"
    }

    // Alerts Section
    Column {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        spacing: 8
        z: 1

        // Error Alert
        Rectangle {
            width: 300
            height: 48
            color: "#7F1D1D"
            radius: 8
            visible: false

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Image {
                    source: "../Icons/alert-circle.svg"
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                }

                Text {
                    text: "Temperature exceeds 80°C"
                    color: "#ffffff"
                    font.pixelSize: 18
                    //font.bold: true
                }
            }
        }

        // Warning Alert
        Rectangle {
            width: 300
            height: 48
            color: "#854D0E"
            radius: 8
            visible: false

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Image {
                    source: "../Icons/alert-triangle.svg"
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                }

                Text {
                    text: "Product tank level below 25%"
                    color: "#ffffff"
                    font.pixelSize: 18
                    //font.bold: true
                }
            }
        }
    }

    //Column Layout for MachineCards
    ColumnLayout {
        anchors {
            fill: parent
            margins: 16
        }
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            //Item for blank spacing
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            //Item for blank spacing
            Item {
                Layout.preferredWidth: 150
                Layout.fillHeight: true
            }

            // Rinsing Machine
            MachineCard {
                id: rinsing
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Rinsing Machine"
                sensorModel: ListModel {
                    ListElement {
                        label: "Temperature"
                        value: "70.5"
                        //value: dataManager.getRinsingTemperature()
                        unit: "°C"
                    }
                    ListElement {
                        label: "Flow Rate"
                        value: "150.2"
                        //value: dataManager.getRinsingFlow()
                        unit: "L/min"
                    }
                    ListElement {
                        label: "pH Level"
                        value: "12.0"
                        //value: dataManager.getRinsingPH()
                        unit: ""
                    }
                }
            }

            SideArrow {
                id: rightArrow
                Layout.preferredWidth: 150
            }

            // Filling Machine
            MachineCard {
                id: filling
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Filling Machine"
                sensorModel: ListModel {
                    ListElement {
                        label: "Tank Level"
                        value: "85"
                        unit: "%"
                    }
                    ListElement {
                        label: "Fill Rate"
                        value: "30"
                        unit: "L/min"
                    }
                    ListElement {
                        label: "Pressure"
                        value: "3.0"
                        unit: "bar"
                    }
                    ListElement {
                        label: "Bottle Weight"
                        value: "375"
                        unit: "g"
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            DownArrow {
                anchors {
                    right: parent.right
                    rightMargin: capping.width / 2
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        //second row
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            //Packing Machine
            MachineCard {
                id: packing
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Packing Machine"
                sensorModel: ListModel {
                    ListElement {
                        label: "Boxes Remaining"
                        value: "5432"
                        unit: ""
                    }
                    ListElement {
                        label: "Box Weight"
                        value: "4.5"
                        unit: "kg"
                    }
                }
            }

            SideLeftArrow {
                Layout.preferredWidth: 150
            }

            //Labeling Machine
            MachineCard {
                id: labeling
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Labeling Machine"
                sensorModel: ListModel {
                    ListElement {
                        label: "Label Quality"
                        value: "OK"
                        unit: ""
                    }
                    ListElement {
                        label: "Labels Remaining"
                        value: "9234"
                        unit: ""
                    }
                    ListElement {
                        label: "Position Offset"
                        value: "0.5"
                        unit: "mm"
                    }
                }
            }

            SideLeftArrow {
                Layout.preferredWidth: 150
            }

            // Capping Machine
            MachineCard {
                id: capping
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Capping Machine"
                sensorModel: ListModel {
                    ListElement {
                        label: "Torque"
                        value: "2.0"
                        unit: "Nm"
                    }
                    ListElement {
                        label: "Caps Remaining"
                        value: "8547"
                        unit: ""
                    }
                }
            }
        }
    }

    Item {
        anchors {
            margins: 16
            ///right: rinsing.left
            left: parent.left
            top: parent.top
            //bottom: packing.top
        }
        height: parent.height - (packing.height + 48)
        width: parent.width - (rinsing.width + rightArrow.width + filling.width + 80)
        DashboardControlCard {
            id: dashboardControl
            anchors.centerIn: parent
        }
    }
}
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Components"
import com.example.backend 1.0

Page {
    DataManager {
        id: dataManager
        Component.onCompleted: dataManager.start()
    }

    background: Rectangle {
        color: "black"
    }

    // Alerts Section
    Column {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        spacing: 8
        z: 1

        // Error Alert
        Rectangle {
            width: 300
            height: 48
            color: "#7F1D1D"
            radius: 8
            visible: false // TODO: Connect to error states

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Image {
                    source: "../Icons/alert-circle.svg"
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                }

                Text {
                    text: "Temperature exceeds 80°C"
                    color: "#ffffff"
                    font.pixelSize: 18
                }
            }
        }

        // Warning Alert
        Rectangle {
            width: 300
            height: 48
            color: "#854D0E"
            radius: 8
            visible: false // TODO: Connect to warning states

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Image {
                    source: "../Icons/alert-triangle.svg"
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                }

                Text {
                    text: "Product tank level below 25%"
                    color: "#ffffff"
                    font.pixelSize: 18
                }
            }
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: 16
        }
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Item {
                Layout.preferredWidth: 150
                Layout.fillHeight: true
            }

            // Rinsing Machine
            MachineCard {
                id: rinsing
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Rinsing Machine"
                sensorModel: ListModel {
                    id: rinsingModel
                    ListElement {
                        label: "Temperature"
                        value: "0.0"
                        unit: "°C"
                    }
                    ListElement {
                        label: "Flow Rate"
                        value: "0.0"
                        unit: "L/min"
                    }
                    ListElement {
                        label: "pH Level"
                        value: "0.0"
                        unit: ""
                    }
                }

                Connections {
                    target: dataManager
                    function onRinsingTemperatureChanged() {
                        rinsingModel.setProperty(
                                    0, "value",
                                    dataManager.rinsingTemperature.toFixed(1))
                    }
                    function onRinsingFlowChanged() {
                        rinsingModel.setProperty(
                                    1, "value",
                                    dataManager.rinsingFlow.toFixed(1))
                    }
                    function onRinsingPHChanged() {
                        rinsingModel.setProperty(
                                    2, "value",
                                    dataManager.rinsingPH.toFixed(1))
                    }
                }
            }

            SideArrow {
                id: rightArrow
                Layout.preferredWidth: 150
            }

            // Filling Machine
            MachineCard {
                id: filling
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Filling Machine"
                sensorModel: ListModel {
                    id: fillingModel
                    ListElement {
                        label: "Tank Level"
                        value: "0"
                        unit: "%"
                    }
                    ListElement {
                        label: "Fill Rate"
                        value: "0"
                        unit: "L/min"
                    }
                    ListElement {
                        label: "Pressure"
                        value: "0.0"
                        unit: "bar"
                    }
                    ListElement {
                        label: "Bottle Weight"
                        value: "0"
                        unit: "g"
                    }
                }

                Connections {
                    target: dataManager
                    function onFillingLevelChanged() {
                        fillingModel.setProperty(
                                    0, "value",
                                    dataManager.fillingLevel.toFixed(1))
                    }
                    function onFillingFlowChanged() {
                        fillingModel.setProperty(
                                    1, "value",
                                    dataManager.fillingFlow.toFixed(1))
                    }
                    function onFillingPressureChanged() {
                        fillingModel.setProperty(
                                    2, "value",
                                    dataManager.fillingPressure.toFixed(1))
                    }
                    function onFillingWeightChanged() {
                        fillingModel.setProperty(
                                    3, "value",
                                    dataManager.fillingWeight.toFixed(0))
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            DownArrow {
                anchors {
                    right: parent.right
                    rightMargin: capping.width / 2
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // Packing Machine
            MachineCard {
                id: packing
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Packing Machine"
                sensorModel: ListModel {
                    id: packingModel
                    ListElement {
                        label: "Boxes Remaining"
                        value: "0"
                        unit: ""
                    }
                    ListElement {
                        label: "Box Weight"
                        value: "0.0"
                        unit: "kg"
                    }
                }

                Connections {
                    target: dataManager
                    function onPackingCountChanged() {
                        packingModel.setProperty(
                                    0, "value",
                                    dataManager.packingCount.toString())
                    }
                    function onPackingWeightChanged() {
                        packingModel.setProperty(
                                    1, "value",
                                    dataManager.packingWeight.toFixed(1))
                    }
                }
            }

            SideLeftArrow {
                Layout.preferredWidth: 150
            }

            // Labeling Machine
            MachineCard {
                id: labeling
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Labeling Machine"
                sensorModel: ListModel {
                    id: labelingModel
                    ListElement {
                        label: "Label Quality"
                        value: "N/A"
                        unit: ""
                    }
                    ListElement {
                        label: "Labels Remaining"
                        value: "0"
                        unit: ""
                    }
                    ListElement {
                        label: "Position Offset"
                        value: "0.0"
                        unit: "mm"
                    }
                }

                Connections {
                    target: dataManager
                    function onLabelingVisionChanged() {
                        labelingModel.setProperty(0, "value",
                                                  dataManager.labelingVision)
                    }
                    function onLabelingCountChanged() {
                        labelingModel.setProperty(
                                    1, "value",
                                    dataManager.labelingCount.toString())
                    }
                    function onLabelingPositionChanged() {
                        labelingModel.setProperty(
                                    2, "value",
                                    dataManager.labelingPosition.toFixed(1))
                    }
                }
            }

            SideLeftArrow {
                Layout.preferredWidth: 150
            }

            // Capping Machine
            MachineCard {
                id: capping
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Capping Machine"
                sensorModel: ListModel {
                    id: cappingModel
                    ListElement {
                        label: "Torque"
                        value: "0.0"
                        unit: "Nm"
                    }
                    ListElement {
                        label: "Caps Remaining"
                        value: "0"
                        unit: ""
                    }
                }

                Connections {
                    target: dataManager
                    function onCappingTorqueChanged() {
                        cappingModel.setProperty(
                                    0, "value",
                                    dataManager.cappingTorque.toFixed(1))
                    }
                    function onCappingCountChanged() {
                        cappingModel.setProperty(
                                    1, "value",
                                    dataManager.cappingCount.toString())
                    }
                }
            }
        }
    }

    Item {
        anchors {
            margins: 16
            left: parent.left
            top: parent.top
        }
        height: parent.height - (packing.height + 48)
        width: parent.width - (rinsing.width + rightArrow.width + filling.width + 80)
        DashboardControlCard {
            id: dashboardControl
            anchors.centerIn: parent
        }
    }
}
