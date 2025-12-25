import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components" 1.0
import ViewModels 1.0  

Page {
    id: page
    title: "Роли"

    property alias roleVm: loader.item
    property var appWindow: ApplicationWindow.window

    header: ToolBar {
        Material.foreground: "white"
        Material.background: "#FF5722"

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
                visible: roleVm ? roleVm.isLoading : false
                running: visible
                Material.accent: "white"
            }

            ToolButton {
                text: "⟳"
                font.pixelSize: 20
                onClicked: roleVm ? roleVm.load() : null
            }
        }
    }

    Loader {
        id: loader
        sourceComponent: RoleViewModel {}
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
                        text: "👥"
                        font.pixelSize: 20
                    }

                    Label {
                        text: "Добавить новую роль"
                        font.bold: true
                        font.pixelSize: 16
                        color: "#FF5722"
                        Layout.fillWidth: true
                    }
                }

                RowLayout {
                    spacing: 12
                    Layout.fillWidth: true

                    TextField {
                        id: roleNameField
                        Layout.fillWidth: true
                        placeholderText: "Введите название роли"
                        Material.accent: "#FF5722"
                        font.pixelSize: 14
                    }

                    Button {
                        text: "Добавить"
                        enabled: roleNameField.text.trim() !== ""
                        Material.background: "#FF5722"
                        Material.foreground: "white"
                        implicitWidth: 120

                        onClicked: {
                            roleVm.addRole(roleNameField.text.trim())
                            roleNameField.clear()
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Label {
                text: "🎭"
                font.pixelSize: 20
            }

            Label {
                text: "Список ролей"
                font.bold: true
                font.pixelSize: 18
                color: "#424242"
                Layout.fillWidth: true
            }

            Label {
                text: roleVm ? roleVm.roles.length : 0
                font.pixelSize: 14
                color: "#757575"
                padding: 4
                background: Rectangle {
                    color: "#FFE0B2"
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
                model: roleVm ? roleVm.roles : []
                spacing: 12
                clip: true

                delegate: Card {
                    width: listView.width - 32
                    height: modelData.userIds && modelData.userIds.length > 0 ? 160 : 120

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
                                color: Qt.lighter("#FF5722", 1.2)

                                Label {
                                    text: "👥"
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
                                        //text: "Пользователей: " + (modelData.userIds ? modelData.userIds.length : 0)
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
                                    deleteDialog.roleId = modelData.id
                                    deleteDialog.roleName = modelData.name
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
                            visible: modelData.userIds && modelData.userIds.length > 0

                            Label {
                                text: "Пользователи с этой ролью:"
                                font.bold: true
                                font.pixelSize: 14
                                color: "#616161"
                            }

                            Flow {
                                Layout.fillWidth: true
                                spacing: 6

                                Repeater {
                                    model: modelData.userIds || []

                                    delegate: Rectangle {
                                        width: childrenRect.width + 12
                                        height: 24
                                        radius: 12
                                        color: Qt.lighter("#FF5722", 1.5)

                                        Label {
                                            text: "ID: " + modelData
                                            font.pixelSize: 11
                                            color: "#FF5722"
                                            anchors.centerIn: parent
                                            padding: 6
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Label {
                    visible: listView.count === 0
                    text: "Роли не найдены"
                    font.pixelSize: 16
                    color: "#9E9E9E"
                    anchors.centerIn: parent
                }
            }
        }
    }

    Dialog {
        id: deleteDialog
        property int roleId: -1
        property string roleName: ""

        title: "Удаление роли"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        width: 400

        ColumnLayout {
            width: parent.width
            spacing: 12

            Label {
                text: "Вы уверены, что хотите удалить роль \"" + deleteDialog.roleName + "\"?"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
            }

            Label {
                text: "Все пользователи с этой ролью также будут удалены."
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                color: "#F44336"
            }
        }

        onAccepted: {
            if (roleVm) {
                roleVm.deleteRole(roleId)
            }
        }
    }

    Connections {
        target: roleVm
        function onError(message) {
            showNotification(message, "error")
        }
        function onSuccess(message) {
            showNotification(message, "success")
        }
    }
}