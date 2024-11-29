// DashboardPage.qml
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
            visible: true

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
            visible: true

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

            // Rinsing Machine
            MachineCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Rinsing Machine"
                sensorModel: ListModel {
                    ListElement {
                        label: "Temperature"
                        value: "70.5"
                        unit: "°C"
                    }
                    ListElement {
                        label: "Flow Rate"
                        value: "150.2"
                        unit: "L/min"
                    }
                    ListElement {
                        label: "pH Level"
                        value: "12.0"
                        unit: ""
                    }
                }
            }

            SideArrow {
                Layout.preferredWidth: 150
            }

            // Filling Machine
            MachineCard {
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

            SideArrow {
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

            DashboardDataCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Item {
                Layout.preferredWidth: 150
                Layout.fillHeight: true
            }

            MachineCard {
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

            MachineCard {
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
        }
    }

    // Machines Grid


    /*
    GridLayout {
        anchors.fill: parent
        anchors.margins: 16
        anchors.topMargin: 80
        columns: 3
        rowSpacing: 16
        columnSpacing: 16

        MachineCard {
            Layout.fillWidth: true
            Layout.fillHeight: true
            title: "Rinsing Machine"
            sensorModel: ListModel {
                ListElement {
                    label: "Temperature"
                    value: "70.5"
                    unit: "°C"
                }
                ListElement {
                    label: "Flow Rate"
                    value: "150.2"
                    unit: "L/min"
                }
                ListElement {
                    label: "pH Level"
                    value: "12.0"
                    unit: ""
                }
            }
        }

        MachineCard {
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

        MachineCard {
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

        MachineCard {
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

        MachineCard {
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
    }
    */
}
