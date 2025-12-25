import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components" 1.0
import ViewModels 1.0  

Page {
    id: page
    title: "Категории ПО"

    property alias categoryVm: loader.item
    property var appWindow: ApplicationWindow.window

    header: ToolBar {
        Material.foreground: "white"
        Material.background: "#2196F3"  

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
                visible: categoryVm ? categoryVm.isLoading : false
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

    
    function refreshData() {
        console.log("CategoriesPage: Обновление данных")
        if (categoryVm) {
            categoryVm.load()
        }
    }

    Timer {
        id: refreshTimer
        interval: 1000
        repeat: false
        onTriggered: refreshData()
    }

    Loader {
        id: loader
        sourceComponent: CategoryViewModel {}
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
                        text: "📁"
                        font.pixelSize: 20
                    }

                    Label {
                        text: "Добавить новую категорию"
                        font.bold: true
                        font.pixelSize: 16
                        color: "#2196F3"
                        Layout.fillWidth: true
                    }
                }

                RowLayout {
                    spacing: 12
                    Layout.fillWidth: true

                    TextField {
                        id: newCategoryField
                        Layout.fillWidth: true
                        placeholderText: "Введите название категории"
                        Material.accent: "#2196F3"
                        font.pixelSize: 14
                        selectByMouse: true
                    }

                    Button {
                        text: "Добавить"
                        enabled: newCategoryField.text.trim() !== ""
                        Material.background: "#2196F3"
                        Material.foreground: "white"
                        font.pixelSize: 14
                        implicitWidth: 120

                        onClicked: {
                            categoryVm.addCategory(newCategoryField.text.trim())
                            newCategoryField.clear()
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
                text: "📂"
                font.pixelSize: 20
            }

            Label {
                text: "Список категорий"
                font.bold: true
                font.pixelSize: 18
                color: "#424242"
                Layout.fillWidth: true
            }

            Label {
                text: categoryVm ? categoryVm.categories.length : 0
                font.pixelSize: 14
                color: "#757575"
                padding: 4
                background: Rectangle {
                    color: "#E3F2FD"
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
                model: categoryVm ? categoryVm.categories : []
                spacing: 12
                clip: true

                delegate: Card {
                    width: listView.width - 32
                    height: modelData.programs && modelData.programs.length > 0 ? 180 : 140

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
                                color: Qt.lighter("#2196F3", 1.2)

                                Label {
                                    text: "📁"
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
                                    elide: Text.ElideRight
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
                                        text: "Программ: " + (modelData.programs ? modelData.programs.length : 0)
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
                                    deleteDialog.categoryId = modelData.id
                                    deleteDialog.categoryName = modelData.name
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
                            visible: modelData.programs && modelData.programs.length > 0

                            Label {
                                text: "Программы в категории:"
                                font.bold: true
                                font.pixelSize: 14
                                color: "#616161"
                            }

                            Flow {
                                Layout.fillWidth: true
                                spacing: 6

                                Repeater {
                                    model: modelData.programs || []

                                    delegate: Rectangle {
                                        width: childrenRect.width + 12
                                        height: 24
                                        radius: 12
                                        color: Qt.lighter("#2196F3", 1.5)

                                        Label {
                                            text: modelData.name
                                            font.pixelSize: 11
                                            color: "#2196F3"
                                            anchors.centerIn: parent
                                            padding: 6
                                        }
                                    }
                                }
                            }
                        }

                        Label {
                            text: "В этой категории пока нет программ"
                            font.italic: true
                            font.pixelSize: 14
                            color: "#9E9E9E"
                            visible: !modelData.programs || modelData.programs.length === 0
                        }
                    }
                }

                Label {
                    visible: listView.count === 0
                    text: "Категории не найдены"
                    font.pixelSize: 16
                    color: "#9E9E9E"
                    anchors.centerIn: parent
                }
            }
        }
    }

    
    Dialog {
        id: deleteDialog
        property int categoryId: -1
        property string categoryName: ""

        title: "Удаление категории"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        width: 400

        ColumnLayout {
            width: parent.width
            spacing: 12

            Label {
                text: "Вы уверены, что хотите удалить категорию \"" + deleteDialog.categoryName + "\"?"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
            }

            Label {
                text: "Все программы в этой категории также будут удалены."
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                color: "#F44336"
            }
        }

        onAccepted: {
            if (categoryVm) {
                categoryVm.deleteCategory(categoryId)
                refreshTimer.start()
            }
        }
    }

}