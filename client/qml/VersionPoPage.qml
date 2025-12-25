import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components" 1.0
import ViewModels 1.0

Page {
    id: page
    title: "Версии ПО"

    property alias versionVm: loader.item
    property alias poVm: poLoader.item
    property var appWindow: ApplicationWindow.window

    header: ToolBar {
        Material.foreground: "white"
        Material.background: "#607D8B"

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
                visible: versionVm ? versionVm.isLoading : false
                running: visible
                Material.accent: "white"
            }

            ToolButton {
                text: "⟳"
                font.pixelSize: 20
                onClicked: {
                    versionVm.load()
                    poVm.load()
                }
            }
        }
    }

    Loader {
        id: loader
        sourceComponent: VersionPoViewModel {}
        onLoaded: item.load()
    }

    Loader {
        id: poLoader
        sourceComponent: PoViewModel {}
        onLoaded: item.load()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        anchors.margins: 16

        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 220  

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16 
                spacing: 12

                RowLayout {
                    spacing: 8

                    Label {
                        text: "🔄"
                        font.pixelSize: 20
                    }

                    Label {
                        text: "Добавить новую версию"
                        font.bold: true
                        font.pixelSize: 16
                        color: "#607D8B"
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
                        id: versionPoComboBox
                        Layout.fillWidth: true
                        textRole: "text"
                        valueRole: "value"
                        Material.accent: "#607D8B"

                        model: ListModel {
                            id: versionPoModel
                        }
                    }

                    Label {
                        text: "Версия:"
                        font.pixelSize: 14
                    }

                    TextField {
                        id: versionField
                        Layout.fillWidth: true
                        placeholderText: "Например: 1.0.0"
                        Material.accent: "#607D8B"
                    }

                    Label {
                        text: "Дата выпуска:"
                        font.pixelSize: 14
                    }

                    TextField {
                        id: dateField
                        Layout.fillWidth: true
                        placeholderText: "ГГГГ-ММ-ДД"
                        Material.accent: "#607D8B"
                        text: new Date().toISOString().split('T')[0]
                    }
                }

                Button {
                    text: "Добавить версию"
                    enabled: versionPoComboBox.currentIndex >= 0 && 
                             versionField.text.trim() !== "" &&
                             dateField.text.trim() !== ""
                    Material.background: "#607D8B"
                    Material.foreground: "white"
                    Layout.alignment: Qt.AlignRight

                    onClicked: {
                        versionVm.addVersion(versionField.text.trim(), dateField.text.trim(), 
                                           versionPoComboBox.currentValue)
                        versionField.clear()
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Label {
                text: "📊"
                font.pixelSize: 20
            }

            Label {
                text: "Список версий"
                font.bold: true
                font.pixelSize: 18
                color: "#424242"
                Layout.fillWidth: true
            }

            Label {
                text: versionVm ? versionVm.versions.length : 0
                font.pixelSize: 14
                color: "#757575"
                padding: 4
                background: Rectangle {
                    color: "#ECEFF1"
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
                model: versionVm ? versionVm.versions : []
                spacing: 12
                clip: true

                delegate: Card {
                    width: listView.width - 32
                    height: 160

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
                                color: Qt.lighter("#607D8B", 1.2)

                                Label {
                                    text: "🔄"
                                    font.pixelSize: 20
                                    anchors.centerIn: parent
                                }
                            }

                            ColumnLayout {
                                spacing: 2
                                Layout.fillWidth: true

                                Label {
                                    text: "Версия " + modelData.version
                                    font.bold: true
                                    font.pixelSize: 18
                                    color: "#212121"
                                }

                                RowLayout {
                                    spacing: 8

                                    Label {
                                        //text: "ID: " + modelData.id
                                        font.pixelSize: 12
                                        color: "#757575"
                                    }

                                    Label {
                                        text: "•"
                                        font.pixelSize: 12
                                        color: "#BDBDBD"
                                    }

                                    Label {
                                        text: "Дата: " + modelData.dateVersion
                                        font.pixelSize: 12
                                        color: "#757575"
                                    }

                                    Label {
                                        text: ""
                                        font.pixelSize: 12
                                        color: "#BDBDBD"
                                    }

                                    Label {
                                        //text: "Программа ID: " + modelData.poId
                                        font.pixelSize: 12
                                        color: "#607D8B"
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
                                    //deleteDialog.versionId = modelData.id
                                    deleteDialog.versionName = "v" + modelData.version
                                    deleteDialog.open()
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#EEEEEE"
                        }
                    }
                }

                Label {
                    visible: listView.count === 0
                    text: "Версии не найдены"
                    font.pixelSize: 16
                    color: "#9E9E9E"
                    anchors.centerIn: parent
                }
            }
        }
    }

    Dialog {
        id: deleteDialog
        property int versionId: -1
        property string versionName: ""

        title: "Удаление версии"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        width: 400

        ColumnLayout {
            width: parent.width
            spacing: 12

            Label {
                text: "Вы уверены, что хотите удалить версию \"" + deleteDialog.versionName + "\"?"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
            }

            Label {
                text: "Эта версия будет удалена из истории программы."
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                color: "#FF9800"
            }
        }

        onAccepted: {
            if (versionVm) {
                versionVm.deleteVersion(versionId)
            }
        }
    }

    function updateVersionPoModel() {
        versionPoModel.clear()
        if (poVm && poVm.programs) {
            for (var i = 0; i < poVm.programs.length; i++) {
                var prog = poVm.programs[i]
                versionPoModel.append({
                    text: prog.name //+ " (ID: " + prog.id + ")",
                    //value: prog.id
                })
            }
        }
    }

    Connections {
        target: poVm
        function onProgramsChanged() {
            updateVersionPoModel()
        }
    }

    Connections {
        target: versionVm
        function onError(message) {
            showNotification(message, "error")
        }
        function onSuccess(message) {
            showNotification(message, "success")
        }
    }
}