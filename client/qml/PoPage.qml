import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components" 1.0
import ViewModels 1.0

Page {
    id: page
    title: "Программы"

    property alias poVm: loader.item
    property alias categoryVm: categoryLoader.item
    property alias versionVm: versionLoader.item  
    property var appWindow: ApplicationWindow.window

    function refreshData() {
        console.log("PoPage: Обновление данных")
        if (poVm) poVm.load()
        if (categoryVm) categoryVm.load()
        if (versionVm) versionVm.load()
    }

    Timer {
        id: refreshTimer
        interval: 1000 
        repeat: false
        
    }

    header: ToolBar {
        Material.foreground: "white"
        Material.background: "#9C27B0"

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
                visible: poVm ? poVm.isLoading : false
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
        sourceComponent: PoViewModel {}
        onLoaded: item.load()
    }

    Loader {
        id: categoryLoader
        sourceComponent: CategoryViewModel {}
        onLoaded: item.load()
    }

    Loader {
        id: versionLoader
        sourceComponent: VersionPoViewModel {}
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
                        text: "💻"
                        font.pixelSize: 20
                    }

                    Label {
                        text: "Добавить новую программу"
                        font.bold: true
                        font.pixelSize: 16
                        color: "#9C27B0"
                        Layout.fillWidth: true
                    }
                }

                GridLayout {
                    columns: 2
                    columnSpacing: 16
                    rowSpacing: 12
                    Layout.fillWidth: true

                    Label {
                        text: "Название:"
                        font.pixelSize: 14
                    }

                    TextField {
                        id: programNameField
                        Layout.fillWidth: true
                        placeholderText: "Введите название программы"
                        Material.accent: "#9C27B0"
                        selectByMouse: true
                        
                        onAccepted: {
                            if (programNameField.text.trim() !== "" && 
                                categoryComboBox.currentIndex >= 0 && 
                                poVm) {
                                poVm.addProgram(programNameField.text.trim(), categoryComboBox.currentValue)
                                programNameField.clear()
                                refreshTimer.start()
                            }
                        }
                    }

                    Label {
                        text: "Категория:"
                        font.pixelSize: 14
                    }

                    ComboBox {
                        id: categoryComboBox
                        Layout.fillWidth: true
                        textRole: "displayText" 
                        valueRole: "value"
                        Material.accent: "#9C27B0"

                        model: ListModel {
                            id: categoryModel
                        }
                    }
                }

                Button {
                    text: "Добавить программу"
                    enabled: programNameField.text.trim() !== "" && categoryComboBox.currentIndex >= 0
                    Material.background: "#9C27B0"
                    Material.foreground: "white"
                    Layout.alignment: Qt.AlignRight

                    onClicked: {
                        poVm.addProgram(programNameField.text.trim(), categoryComboBox.currentValue)
                        programNameField.clear()
                        refreshTimer.start()  
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Label {
                text: "📦"
                font.pixelSize: 20
            }

            Label {
                text: "Список программ"
                font.bold: true
                font.pixelSize: 18
                color: "#424242"
                Layout.fillWidth: true
            }

            Label {
                text: poVm ? poVm.programs.length : 0
                font.pixelSize: 14
                color: "#757575"
                padding: 4
                background: Rectangle {
                    color: "#F3E5F5"
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
                model: poVm ? poVm.programs : []
                spacing: 12
                clip: true

                delegate: Card {
                    width: listView.width - 32
                    height: getCardHeight()

                    function getCardHeight() {
                        var baseHeight = 180;
                        var versionsCount = getProgramVersions(modelData.id).length;
                        return baseHeight + (versionsCount * 50);
                    }

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
                                color: Qt.lighter("#9C27B0", 1.2)

                                Label {
                                    text: "💻"
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
                                        text: "Инвентарный: SW-" + modelData.id
                                        font.pixelSize: 12
                                        color: "#757575"
                                    }

                                    Label {
                                        text: "•"
                                        font.pixelSize: 12
                                        color: "#BDBDBD"
                                    }

                                    Label {
                                        text: "Категория: " + getCategoryDisplayName(modelData.categoryId)
                                        font.pixelSize: 12
                                        color: "#757575"
                                    }

                                    Label {
                                        text: "•"
                                        font.pixelSize: 12
                                        color: "#BDBDBD"
                                    }

                                    Label {
                                        text: "Версий: " + getProgramVersions(modelData.id).length
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
                                    deleteDialog.poId = modelData.id
                                    deleteDialog.poName = modelData.name
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
                            spacing: 6

                            Label {
                                text: "Версии программы:"
                                font.bold: true
                                font.pixelSize: 14
                                color: "#616161"
                            }

                            Repeater {
                                model: getProgramVersions(modelData.id)

                                delegate: RowLayout {
                                    spacing: 8
                                    width: parent.width

                                    Label {
                                        text: "🔄"
                                        font.pixelSize: 14
                                    }

                                    Label {
                                        text: "v" + modelData.version
                                        font.pixelSize: 14
                                        color: "#9C27B0"
                                    }

                                    Label {
                                        text: "(" + modelData.dateVersion + ")"
                                        font.pixelSize: 12
                                        color: "#757575"
                                    }

                                    Item { Layout.fillWidth: true }

                                    Label {
                                        text: "" 
                                        font.pixelSize: 12
                                        color: "#4CAF50"
                                        font.bold: true
                                        visible: false //TODO доделать
                                    }
                                }
                            }
                        }

                        Label {
                            text: "Для этой программы пока нет версий"
                            font.italic: true
                            font.pixelSize: 14
                            color: "#9E9E9E"
                            visible: getProgramVersions(modelData.id).length === 0
                        }
                    }
                }

                Label {
                    visible: listView.count === 0
                    text: "Программы не найдены"
                    font.pixelSize: 16
                    color: "#9E9E9E"
                    anchors.centerIn: parent
                }
            }
        }
    }

    Dialog {
        id: deleteDialog
        property int poId: -1
        property string poName: ""

        title: "Удаление программы"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        width: 400

        ColumnLayout {
            width: parent.width
            spacing: 12

            Label {
                text: "Вы уверены, что хотите удалить программу \"" + deleteDialog.poName + "\"?"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
            }

            Label {
                text: "Все версии этой программы и установки будут удалены."
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                color: "#F44336"
            }
        }

        onAccepted: {
            if (poVm) {
                poVm.deleteProgram(poId)
                refreshTimer.start() 
            }
        }
    }

    function updateCategoryModel() {
        categoryModel.clear()
        if (categoryVm && categoryVm.categories) {
            for (var i = 0; i < categoryVm.categories.length; i++) {
                var cat = categoryVm.categories[i]
                categoryModel.append({
                    displayText: cat.name,  
                    text: cat.name,
                    value: cat.id
                })
            }
        }
    }

    function getCategoryDisplayName(categoryId) {
        if (!categoryVm || !categoryVm.categories) return "Категория ID:" + categoryId;
        
        var category = categoryVm.categories.find(function(cat) {
            return cat.id === categoryId;
        });
        
        return category ? category.name : "Категория ID:" + categoryId;
    }

    function getProgramVersions(programId) {
        if (!versionVm || !versionVm.versions) return [];
        
        return versionVm.versions.filter(function(version) {
            return version.poId === programId;
        });
    }

    Connections {
        target: categoryVm
        enabled: categoryVm !== null
        
        function onCategoriesChanged() {
            updateCategoryModel()
        }
        
        function onSuccess(message) {
            console.log("PoPage: Category успех -", message)
            refreshTimer.restart()
        }
    }

    Connections {
        target: versionVm
        enabled: versionVm !== null
        
        function onVersionsChanged() {
            if (listView.model) {
                listView.model = listView.model;
            }
        }
        
        function onSuccess(message) {
            console.log("PoPage: Version успех -", message)
            refreshTimer.restart()
        }
    }

    Connections {
        target: poVm
        enabled: poVm !== null
        
        function onError(message) {
            console.log("PoPage: Ошибка -", message)
            showNotification(message, "error")
        }
        
        function onSuccess(message) {
            console.log("PoPage: Успех -", message)
            showNotification(message, "success")
            refreshTimer.restart()
        }
        
        function onProgramsChanged() {
            updateCategoryModel();
        }
    }

    Component.onCompleted: {
        if (poVm) poVm.load();
        if (categoryVm) categoryVm.load();
        if (versionVm) versionVm.load();
    }
    
    onVisibleChanged: {
        if (visible && poVm) {
            console.log("PoPage: Страница стала видимой")
            refreshData()
        }
    }
}