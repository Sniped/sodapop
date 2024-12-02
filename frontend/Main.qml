// main.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Components"
import "Pages"

ApplicationWindow {
    id: window
    visible: true
    visibility: Window.Maximized
    width: 1920
    height: 1080
    title: "Factory HMI"
    color: "#000000"

    property int currentPage: 0 // 0 for dashboard, 1 for logs

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Navigation Sidebar
        Rectangle {
            Layout.preferredWidth: 80
            Layout.fillHeight: true
            color: "#111827"
            border.color: "#1F2937"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                anchors.topMargin: 25
                spacing: 24

                // User Icon

                /*
                Image {
                    width: 32
                    height: 32
                    Layout.alignment: Qt.AlignHCenter
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectFit
                    source: "Icons/user.svg"
                }
                */

                // Navigation Buttons
                NavButton {
                    Layout.alignment: Qt.AlignHCenter
                    active: currentPage === 0
                    iconSource: "../Icons/dashboard.svg"
                    pageName: "Dashboard"
                    onClicked: currentPage = 0
                }

                NavButton {
                    Layout.alignment: Qt.AlignHCenter
                    active: currentPage === 1
                    iconSource: "../Icons/logs.svg"
                    pageName: "Logs"
                    onClicked: currentPage = 1
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }

        // Main Content
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: currentPage

            DashboardPage {}
            LogsPage {}
        }
    }
}
