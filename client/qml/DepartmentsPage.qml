import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components" 1.0
import ViewModels 1.0

Page {
    id: page
    title: "Отделы"

    property alias departmentVm: loader.item
    property var appWindow: ApplicationWindow.window

    function refreshData() {
        console.log("DepartmentsPage: Обновление данных")
        if (departmentVm) {
            departmentVm.load()
        }
    }

    Timer {
        id: refreshTimer
        interval: 1000
        repeat: false
        
        onTriggered: {
            console.log("DepartmentsPage: Таймер автообновления сработал")
            refreshData()
        }
    }

    header: ToolBar {
        Material.foreground: "white"
        Material.background: "#4CAF50"

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
                visible: departmentVm ? departmentVm.isLoading : false
                running: visible
                Material.accent: "white"
            }

            ToolButton {
                text: "⟳"
                font.pixelSize: 20
                onClicked: refreshData()
            }
        }
    }

    Loader {
        id: loader
        sourceComponent: DepartmentViewModel {}
        onLoaded: item.load()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        anchors.margins: 16

        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 150

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                RowLayout {
                    spacing: 8

                    Label {
                        text: "🏢"
                        font.pixelSize: 20
                    }

                    Label {
                        text: "Добавить новый отдел"
                        font.bold: true
                        font.pixelSize: 16
                        color: "#4CAF50"
                        Layout.fillWidth: true
                    }
                }

                RowLayout {
                    spacing: 12
                    Layout.fillWidth: true

                    TextField {
                        id: newDepartmentField
                        Layout.fillWidth: true
                        placeholderText: "Введите название отдела"
                        Material.accent: "#4CAF50"
                        font.pixelSize: 14
                        selectByMouse: true
                        
                        onAccepted: {
                            if (newDepartmentField.text.trim() !== "" && departmentVm) {
                                departmentVm.addDepartment(newDepartmentField.text.trim())
                                newDepartmentField.clear()
                                refreshTimer.start()  
                            }
                        }
                    }

                    Button {
                        text: "Добавить"
                        enabled: newDepartmentField.text.trim() !== ""
                        Material.background: "#4CAF50"
                        Material.foreground: "white"
                        implicitWidth: 120

                        onClicked: {
                            departmentVm.addDepartment(newDepartmentField.text.trim())
                            newDepartmentField.clear()
                            refreshTimer.start()  
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Label {
                text: "📋"
                font.pixelSize: 20
            }

            Label {
                text: "Список отделов"
                font.bold: true
                font.pixelSize: 18
                color: "#424242"
                Layout.fillWidth: true
            }

            Label {
                text: departmentVm ? departmentVm.departments.length : 0
                font.pixelSize: 14
                color: "#757575"
                padding: 4
                background: Rectangle {
                    color: "#E8F5E9"
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
                model: departmentVm ? departmentVm.departments : []
                spacing: 12
                clip: true

                delegate: Card {
                    width: listView.width - 32
                    height: modelData.pcs && modelData.pcs.length > 0 ? 180 : 140

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
                                color: Qt.lighter("#4CAF50", 1.2)

                                Label {
                                    text: "🏢"
                                    font.pixelSize: 20
                                    anchors.centerIn: parent
                                }
                            }

                            ColumnLayout {
                                spacing: 2
                                Layout.fillWidth: true

                                Label {
                                    text: modelData.name
                                    font.bold: true
                                    font.pixelSize: 18
                                    color: "#212121"
                                }

                                RowLayout {
                                    spacing: 8

                                    Label {
                                        font.pixelSize: 12
                                        color: "#757575"
                                    }

                                    Label {
                                        text: "•"
                                        font.pixelSize: 12
                                        color: "#BDBDBD"
                                    }

                                    Label {
                                        text: "Компьютеров: " + (modelData.pcs ? modelData.pcs.length : 0)
                                        font.pixelSize: 12
                                        color: "#757575"
                                    }

                                    Label {
                                        text: "•"
                                        font.pixelSize: 12
                                        color: "#BDBDBD"
                                    }

                                    Label {
                                        text: "Пользователей: " + (modelData.users ? modelData.users.length : 0)
                                        font.pixelSize: 12
                                        color: "#757575"
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
                                    deleteDialog.departmentId = modelData.id
                                    deleteDialog.departmentName = modelData.name
                                    deleteDialog.open()
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#EEEEEE"
                        }

                        ColumnLayout {
                            spacing: 8
                            visible: modelData.pcs && modelData.pcs.length > 0

                            Label {
                                text: "Компьютеры в отделе:"
                                font.bold: true
                                font.pixelSize: 14
                                color: "#616161"
                            }

                            Flow {
                                Layout.fillWidth: true
                                spacing: 6

                                Repeater {
                                    model: modelData.pcs || []

                                    delegate: Rectangle {
                                        width: Math.min(label.implicitWidth + 12, 200)  
                                        height: 24
                                        radius: 12
                                        color: Qt.lighter("#4CAF50", 1.5)

                                        Label {
                                            id: label
                                            text: modelData.name
                                            font.pixelSize: 11
                                            color: "#4CAF50"
                                            anchors.centerIn: parent
                                            padding: 6
                                        }
                                    }
                                }
                            }
                        }

                        Label {
                            text: "В этом отделе пока нет компьютеров"
                            font.italic: true
                            font.pixelSize: 14
                            color: "#9E9E9E"
                            visible: !modelData.pcs || modelData.pcs.length === 0
                        }
                    }
                }

                Label {
                    visible: listView.count === 0
                    text: "Отделы не найдены"
                    font.pixelSize: 16
                    color: "#9E9E9E"
                    anchors.centerIn: parent
                }
            }
        }
    }

    Dialog {
        id: deleteDialog
        property int departmentId: -1
        property string departmentName: ""

        title: "Удаление отдела"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        width: 400

        ColumnLayout {
            width: parent.width
            spacing: 12

            Label {
                text: "Вы уверены, что хотите удалить отдел \"" + deleteDialog.departmentName + "\"?"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
            }

            Label {
                text: "Все компьютеры и пользователи этого отдела также будут удалены."
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                color: "#F44336"
            }
        }

        onAccepted: {
            if (departmentVm) {
                departmentVm.deleteDepartment(departmentId)
                refreshTimer.start()
            }
        }
    }

    Connections {
        target: departmentVm
        enabled: departmentVm !== null
        
        function onError(message) {
            console.log("DepartmentsPage: Ошибка -", message)
            showNotification(message, "error")
        }
        
        function onSuccess(message) {
            console.log("DepartmentsPage: Успех -", message)
            showNotification(message, "success")
            refreshTimer.restart()
        }
    }
    
    Component.onCompleted: {
        if (departmentVm) {
            refreshData()
        }
    }
    
    onVisibleChanged: {
        if (visible && departmentVm) {
            console.log("DepartmentsPage: Страница стала видимой")
            refreshData()
        }
    }
}