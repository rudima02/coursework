import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components" 1.0
import ViewModels 1.0

Page {
    id: page
    title: "Отчёты"

    property alias reportVm: loader.item
    property var appWindow: ApplicationWindow.window

    header: ToolBar {
        Material.background: "#2196F3"
        Material.foreground: "white"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16

            ToolButton {
                text: "☰"
                onClicked: page.appWindow.globalDrawer.open()
            }

            Label {
                text: page.title
                Layout.fillWidth: true
                font.pixelSize: 20
                font.bold: true
            }

            BusyIndicator {
                visible: reportVm ? reportVm.isLoading : false
                running: visible
            }
        }
    }

    Loader {
        id: loader
        sourceComponent: ReportViewModel {}
        onLoaded: item.load()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: listView
                anchors.fill: parent
                anchors.margins: 16
                model: reportVm ? reportVm.departments : []
                spacing: 12

                delegate: Card {
                    width: listView.width - 32
                    height: 70

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16

                        Label {
                            text: modelData.name
                            Layout.fillWidth: true
                            font.bold: true
                        }

                        Label { text: "ПК: " + modelData.pcCount }
                        Label { text: "ПО: " + modelData.poCount }
                        Label { text: "Польз.: " + modelData.userCount }
                    }
                }

                Label {
                    visible: listView.count === 0 && !reportVm.isLoading
                    text: "Нет данных"
                    anchors.centerIn: parent
                    color: "#9E9E9E"
                }
            }
        }

        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 60

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16

                Label { text: "ПК: " + reportVm.totalPc }
                Item { Layout.fillWidth: true }
                Label { text: "ПО: " + reportVm.totalPo }
                Item { Layout.fillWidth: true }
                Label { text: "Польз.: " + reportVm.totalUsers }
            }
        }
    }

    Connections {
        target: reportVm
        function onError(msg) { showNotification(msg, "error") }
        function onSuccess(msg) { showNotification(msg, "success") }
    }
}
