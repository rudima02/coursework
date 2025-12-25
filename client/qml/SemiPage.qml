import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components" 1.0
import ViewModels 1.0

Page {
    id: page
    title: "Установки ПО"

    property alias semiVm: loader.item
    property alias poVm: poLoader.item
    property alias pcVm: pcLoader.item
    property var appWindow: ApplicationWindow.window

    header: ToolBar {
        Material.foreground: "white"
        Material.background: "#795548"

        RowLayout {
            anchors.fill: parent
            spacing: 16

            ToolButton {
                text: "☰"
                font.pixelSize: 24
                onClicked: page.appWindow.globalDrawer.open()
            }

            Label {
                text: page.title
                Layout.fillWidth: true
                font.pixelSize: 20
                font.bold: true
                horizontalAlignment: Text.AlignLeft
            }

            BusyIndicator {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                visible: semiVm ? semiVm.isLoading : false
                running: visible
                Material.accent: "white"
            }

            ToolButton {
                text: "⟳"
                font.pixelSize: 20
                onClicked: {
                    semiVm.load()
                    poVm.load()
                    pcVm.load()
                }
            }
        }
    }

    Loader {
        id: loader
        sourceComponent: SemiViewModel {}
        onLoaded: item.load()
    }

    Loader {
        id: poLoader
        sourceComponent: PoViewModel {}
        onLoaded: item.load()
    }

    Loader {
        id: pcLoader
        sourceComponent: PcViewModel {}
        onLoaded: item.load()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        anchors.margins: 16 

        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 200

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                RowLayout {
                    spacing: 8

                    Label {
                        text: "📦"
                        font.pixelSize: 20
                    }

                    Label {
                        text: "Установить программу на компьютер"
                        font.bold: true
                        font.pixelSize: 16
                        color: "#795548"
                        Layout.fillWidth: true
                    }
                }

                GridLayout {
                    columns: 2
                    columnSpacing: 16
                    rowSpacing: 12
                    Layout.fillWidth: true

                    Label {
                        text: "Программа:"
                        font.pixelSize: 14
                    }

                    ComboBox {
                        id: semiPoComboBox
                        Layout.fillWidth: true
                        textRole: "text"
                        valueRole: "value"
                        Material.accent: "#795548"

                        model: ListModel {
                            id: semiPoModel
                        }
                    }

                    Label {
                        text: "Компьютер:"
                        font.pixelSize: 14
                    }

                    ComboBox {
                        id: semiPcComboBox
                        Layout.fillWidth: true
                        textRole: "text"
                        valueRole: "value"
                        Material.accent: "#795548"

                        model: ListModel {
                            id: semiPcModel
                        }
                    }
                }

                Button {
                    text: "Установить"
                    enabled: semiPoComboBox.currentIndex >= 0 && semiPcComboBox.currentIndex >= 0
                    Material.background: "#795548"
                    Material.foreground: "white"
                    Layout.alignment: Qt.AlignRight

                    onClicked: {
                        semiVm.addInstallation(semiPoComboBox.currentValue, semiPcComboBox.currentValue)
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Label {
                text: "🔗"
                font.pixelSize: 20
            }

            Label {
                text: "Список установок"
                font.bold: true
                font.pixelSize: 18
                color: "#424242"
                Layout.fillWidth: true
            }

            Label {
                text: semiVm ? semiVm.installations.length : 0
                font.pixelSize: 14
                color: "#757575"
                padding: 4
                background: Rectangle {
                    color: "#D7CCC8"
                    radius: 4
                }
            }
        }

        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: listView
                anchors.fill: parent
                anchors.margins: 16
                model: semiVm ? semiVm.installations : []
                spacing: 12
                clip: true

                delegate: Card {
                    width: listView.width - 32
                    height: 140

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        RowLayout {
                            spacing: 12

                            Rectangle {
                                width: 40
                                height: 40
                                radius: 20
                                color: Qt.lighter("#795548", 1.2)

                                Label {
                                    text: "📦"
                                    font.pixelSize: 20
                                    anchors.centerIn: parent
                                }
                            }

                            ColumnLayout {
                                spacing: 2
                                Layout.fillWidth: true

                                Label {
                                    text: "Установка #" + modelData.id
                                    font.bold: true
                                    font.pixelSize: 18
                                    color: "#212121"
                                }

                                RowLayout {
                                    spacing: 8

                                    Label {
                                        //text: "Программа: " + version.version
                                        font.pixelSize: 12
                                        color: "#795548"
                                        font.bold: true
                                    }

                                    Label {
                                        text: "→"
                                        font.pixelSize: 12
                                        color: "#BDBDBD"
                                    }

                                    Label {
                                        //text: "Компьютер: " + computer.name
                                        font.pixelSize: 12
                                        color: "#795548"
                                        font.bold: true
                                    }
                                }
                            }

                            Button {
                                text: "✕"
                                Material.background: "#FF5252"
                                Material.foreground: "white"
                                implicitWidth: 32
                                implicitHeight: 32

                                onClicked: {
                                    deleteDialog.semiId = modelData.id
                                    deleteDialog.open()
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#EEEEEE"
                        }

                        GridLayout {
                            columns: 2
                            columnSpacing: 16
                            rowSpacing: 8
                            Layout.fillWidth: true

                            Label {
                                text: "Статус:"
                                font.pixelSize: 14
                                color: "#616161"
                            }

                            Label {
                                text: "Активна"
                                font.pixelSize: 14
                                color: "#4CAF50"
                                font.bold: true
                            }
                        }
                    }
                }

                Label {
                    visible: listView.count === 0
                    text: "Установки не найдены"
                    font.pixelSize: 16
                    color: "#9E9E9E"
                    anchors.centerIn: parent
                }
            }
        }
    }

    Dialog {
        id: deleteDialog
        property int semiId: -1

        title: "Удаление установки"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        width: 400

        ColumnLayout {
            width: parent.width
            spacing: 12

            Label {
                text: "Вы уверены, что хотите удалить эту установку?"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
            }

            Label {
                text: "Программа будет удалена с компьютера."
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                color: "#F44336"
            }

            RowLayout {
                spacing: 8
                Layout.alignment: Qt.AlignHCenter

                Label {
                    font.pixelSize: 12
                    color: "#795548"
                }

                Label {
                    text: "→"
                    font.pixelSize: 12
                    color: "#BDBDBD"
                }

                Label {
                    font.pixelSize: 12
                    color: "#795548"
                }
            }
        }

        onAccepted: {
            if (semiVm) {
                semiVm.deleteInstallation(semiId)
            }
        }
    }

    function updateSemiPoModel() {
        semiPoModel.clear()
        if (poVm && poVm.programs) {
            for (var i = 0; i < poVm.programs.length; i++) {
                var prog = poVm.programs[i]
                semiPoModel.append({
                    text: prog.name,
                    //value: prog.id
                })
            }
        }
    }

    function updateSemiPcModel() {
        semiPcModel.clear()
        if (pcVm && pcVm.computers) {
            for (var i = 0; i < pcVm.computers.length; i++) {
                var comp = pcVm.computers[i]
                semiPcModel.append({
                    text: comp.name,
                    //value: comp.id
                })
            }
        }
    }

    Connections {
        target: poVm
        function onProgramsChanged() {
            updateSemiPoModel()
        }
    }

    Connections {
        target: pcVm
        function onComputersChanged() {
            updateSemiPcModel()
        }
    }

}