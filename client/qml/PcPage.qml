import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components" 1.0
import ViewModels 1.0

Page {
    id: page
    title: "Компьютеры"

    property alias pcVm: loader.item
    property alias departmentVm: departmentLoader.item
    property alias semiVm: semiLoader.item
    property alias poVm: poLoader.item
    property var appWindow: ApplicationWindow.window

    function refreshData() {
        console.log("PcPage: Обновление данных")
        if (pcVm) pcVm.load()
        if (departmentVm) departmentVm.load()
        if (semiVm) semiVm.load()
        if (poVm) poVm.load()
    }

    Timer {
        id: refreshTimer
        interval: 1000
        repeat: false
        
    }

    header: ToolBar {
        Material.foreground: "white"
        Material.background: "#FF9800"

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
                visible: pcVm ? pcVm.isLoading : false
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
        sourceComponent: PcViewModel {}
        onLoaded: item.load()
    }

    Loader {
        id: departmentLoader
        sourceComponent: DepartmentViewModel {}
        onLoaded: item.load()
    }

    Loader {
        id: semiLoader
        sourceComponent: SemiViewModel {}
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
            Layout.preferredHeight: 200

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                RowLayout {
                    spacing: 8

                    Label {
                        text: "🖥️"
                        font.pixelSize: 20
                    }

                    Label {
                        text: "Добавить новый компьютер"
                        font.bold: true
                        font.pixelSize: 16
                        color: "#FF9800"
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
                        id: pcNameField
                        Layout.fillWidth: true
                        placeholderText: "Введите название компьютера"
                        Material.accent: "#FF9800"
                        selectByMouse: true
                        
                        onAccepted: {
                            if (pcNameField.text.trim() !== "" && 
                                departmentComboBox.currentIndex >= 0 && 
                                pcVm) {
                                pcVm.addComputer(pcNameField.text.trim(), departmentComboBox.currentValue)
                                pcNameField.clear()
                                refreshTimer.start()
                            }
                        }
                    }

                    Label {
                        text: "Отдел:"
                        font.pixelSize: 14
                    }

                    ComboBox {
                        id: departmentComboBox
                        Layout.fillWidth: true
                        textRole: "displayText"
                        valueRole: "value"
                        Material.accent: "#FF9800"

                        model: ListModel {
                            id: departmentModel
                        }
                    }
                }

                Button {
                    text: "Добавить компьютер"
                    enabled: pcNameField.text.trim() !== "" && departmentComboBox.currentIndex >= 0
                    Material.background: "#FF9800"
                    Material.foreground: "white"
                    Layout.alignment: Qt.AlignRight

                    onClicked: {
                        pcVm.addComputer(pcNameField.text.trim(), departmentComboBox.currentValue)
                        pcNameField.clear()
                        refreshTimer.start()
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Label {
                text: "💾"
                font.pixelSize: 20
            }

            Label {
                text: "Список компьютеров"
                font.bold: true
                font.pixelSize: 18
                color: "#424242"
                Layout.fillWidth: true
            }

            Label {
                text: pcVm ? pcVm.computers.length : 0
                font.pixelSize: 14
                color: "#757575"
                padding: 4
                background: Rectangle {
                    color: "#FFF3E0"
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
                model: pcVm ? pcVm.computers : []
                spacing: 12
                clip: true

                delegate: Card {
                    width: listView.width - 32
                    height: getCardHeight()

                    function getCardHeight() {
                        var baseHeight = 160;
                        var programs = getInstalledPrograms(modelData.id);
                        var programsCount = programs.length;
                        
                        if (programsCount === 0) {
                            return baseHeight;
                        }
                        
                        var programsHeight = 30 + (Math.min(programsCount, 3) * 30);
                        
                        if (programsCount > 3) {
                            programsHeight += 30;
                        }
                        
                        return baseHeight + programsHeight;
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
                                color: Qt.lighter("#FF9800", 1.2)

                                Label {
                                    text: "🖥️"
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
                                        text: "Инвентарный: PC-" + modelData.id
                                        font.pixelSize: 12
                                        color: "#757575"
                                    }

                                    Label {
                                        text: "•"
                                        font.pixelSize: 12
                                        color: "#BDBDBD"
                                    }

                                    Label {
                                        text: "Отдел: " + getDepartmentName(modelData.departmentId)
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
                                    deleteDialog.pcId = modelData.id
                                    deleteDialog.pcName = modelData.name
                                    deleteDialog.open()
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#EEEEEE"
                        }

                        Label {
                            text: "Установленные программы: " + getInstalledPrograms(modelData.id).length
                            font.pixelSize: 14
                            color: "#616161"
                        }

                        ColumnLayout {
                            id: programsColumn
                            spacing: 6
                            Layout.fillWidth: true
                            visible: installedPrograms.length > 0
                            
                            property var installedPrograms: getInstalledPrograms(modelData.id)

                            Repeater {
                                model: Math.min(programsColumn.installedPrograms.length, 3)

                                delegate: RowLayout {
                                    width: parent.width
                                    spacing: 8
                                    height: 28

                                    Rectangle {
                                        width: 24
                                        height: 24
                                        radius: 12
                                        color: Qt.lighter("#FF9800", 1.5)

                                        Label {
                                            text: "📦"
                                            font.pixelSize: 12
                                            anchors.centerIn: parent
                                        }
                                    }

                                    Label {
                                        text: {
                                            var program = programsColumn.installedPrograms[index];
                                            return program && program.name ? program.name : "Неизвестная программа";
                                        }
                                        font.pixelSize: 12
                                        color: "#FF9800"
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                        Layout.maximumWidth: parent.width - 100
                                    }
                                }
                            }

                            RowLayout {
                                visible: programsColumn.installedPrograms.length > 3
                                spacing: 8
                                height: 28

                                Rectangle {
                                    width: 24
                                    height: 24
                                    radius: 12
                                    color: Qt.lighter("#FF5722", 1.5)

                                    Label {
                                        text: "+"
                                        font.pixelSize: 12
                                        anchors.centerIn: parent
                                    }
                                }

                                Label {
                                    text: "еще " + (programsColumn.installedPrograms.length - 3) + " программ"
                                    font.pixelSize: 12
                                    color: "#FF5722"
                                    font.italic: true
                                }
                            }
                        }

                        Label {
                            text: "На этом компьютере пока нет установленных программ"
                            font.italic: true
                            font.pixelSize: 14
                            color: "#9E9E9E"
                            visible: getInstalledPrograms(modelData.id).length === 0
                        }
                    }
                }

                Label {
                    visible: listView.count === 0
                    text: "Компьютеры не найдены"
                    font.pixelSize: 16
                    color: "#9E9E9E"
                    anchors.centerIn: parent
                }
            }
        }
    }

    Dialog {
        id: deleteDialog
        property int pcId: -1
        property string pcName: ""

        title: "Удаление компьютера"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        width: 400

        ColumnLayout {
            width: parent.width
            spacing: 12

            Label {
                text: "Вы уверены, что хотите удалить компьютер \"" + deleteDialog.pcName + "\"?"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
            }

            Label {
                text: "Все установки ПО на этом компьютере будут удалены."
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                color: "#FF9800"
            }
        }

        onAccepted: {
            if (pcVm) {
                pcVm.deleteComputer(pcId)
                refreshTimer.start()  
            }
        }
    }

    function getDepartmentName(departmentId) {
        if (!departmentVm || !departmentVm.departments) return "Отдел ID:" + departmentId;
        
        for (var i = 0; i < departmentVm.departments.length; i++) {
            var dept = departmentVm.departments[i];
            if (dept && dept.id === departmentId) {
                return dept.name;
            }
        }
        
        return "Отдел ID:" + departmentId;
    }

    function getInstalledPrograms(computerId) {
        var programs = [];
        
        if (!semiVm || !semiVm.installations || !poVm || !poVm.programs) {
            return programs;
        }
        
        var computerInstallations = [];
        
        for (var i = 0; i < semiVm.installations.length; i++) {
            var install = semiVm.installations[i];
            if (install && install.pcId === computerId) {
                computerInstallations.push(install);
            }
        }
        
        for (var j = 0; j < computerInstallations.length; j++) {
            var installation = computerInstallations[j];
            var programFound = null;
            
            for (var k = 0; k < poVm.programs.length; k++) {
                var program = poVm.programs[k];
                if (program && program.id === installation.poId) {
                    programFound = program;
                    break;
                }
            }
            
            if (programFound) {
                programs.push({
                    id: installation.poId,
                    name: programFound.name,
                    installationId: installation.id
                });
            } else {
                programs.push({
                    id: installation.poId,
                    name: "Программа ID:" + installation.poId,
                    installationId: installation.id
                });
            }
        }
        
        return programs;
    }

    function updateDepartmentModel() {
        departmentModel.clear()
        if (departmentVm && departmentVm.departments) {
            for (var i = 0; i < departmentVm.departments.length; i++) {
                var dept = departmentVm.departments[i]
                departmentModel.append({
                    displayText: dept.name, 
                    text: dept.name,
                    value: dept.id
                })
            }
        }
    }

    Connections {
        target: departmentVm
        enabled: departmentVm !== null
        
        function onDepartmentsChanged() {
            updateDepartmentModel()
        }
        
        function onSuccess(message) {
            console.log("PcPage: Department успех -", message)
            refreshTimer.restart()
        }
    }

    Connections {
        target: semiVm
        enabled: semiVm !== null
        
        function onInstallationsChanged() {
            if (listView.model) {
                listView.model = listView.model;
            }
        }
        
        function onSuccess(message) {
            console.log("PcPage: Semi успех -", message)
            refreshTimer.restart()
        }
    }

    Connections {
        target: poVm
        enabled: poVm !== null
        
        function onProgramsChanged() {
            if (listView.model) {
                listView.model = listView.model;
            }
        }
        
        function onSuccess(message) {
            console.log("PcPage: Po успех -", message)
            refreshTimer.restart()
        }
    }

    Connections {
        target: pcVm
        enabled: pcVm !== null
        
        function onError(message) {
            console.log("PcPage: Ошибка -", message)
            showNotification(message, "error")
        }
        
        function onSuccess(message) {
            console.log("PcPage: Успех -", message)
            showNotification(message, "success")
            refreshTimer.restart()
        }
        
        function onComputersChanged() {
            updateDepartmentModel();
        }
    }

    Component.onCompleted: {
        if (pcVm) pcVm.load();
        if (departmentVm) departmentVm.load();
        if (semiVm) semiVm.load();
        if (poVm) poVm.load();
    }
    
    onVisibleChanged: {
        if (visible && pcVm) {
            console.log("PcPage: Страница стала видимой")
            refreshData()
        }
    }
}