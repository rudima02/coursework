import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components" 1.0
import ViewModels 1.0

Page {
    id: page
    title: "Администрирование"
    
    AdminViewModel {
        id: adminVm
        onSuccess: handleAdminSuccess(message)
        onError: handleAdminError(message)
    }
    
    property var appWindow: ApplicationWindow.window
    
    DepartmentViewModel {
        id: departmentVm
        onError: handleDepartmentError(message)
        onDepartmentsChanged: {
            console.log("AdminPage: departmentsChanged, количество:", departmentVm.departments.length)
            updateStatus()
        }
        onIsLoadingChanged: {
            console.log("AdminPage: departmentVm isLoading изменено на", departmentVm.isLoading)
            updateStatus()
        }
    }
    
    PoViewModel {
        id: poVm
        onError: handlePoError(message)
        onProgramsChanged: {
            console.log("AdminPage: programsChanged, количество:", poVm.programs.length)
            updateStatus()
        }
        onIsLoadingChanged: {
            console.log("AdminPage: poVm isLoading изменено на", poVm.isLoading)
            updateStatus()
        }
    }
    
    property bool isPoLoaded: false
    property bool hasSoftware: false
    property bool isDepartmentsLoaded: false
    property bool hasDepartments: false

    Timer {
        id: refreshTimer
        interval: 1000
        repeat: false
        
        onTriggered: {
            console.log("AdminPage: Таймер автообновления сработал")
            refreshData()
        }
    }

    function refreshData() {
        console.log("AdminPage: Обновление данных")
        if (departmentVm) departmentVm.load()
        if (poVm) poVm.load()
    }

    Component.onCompleted: {
        console.log("AdminPage: Component.onCompleted")
        loadData()
    }

    function loadData() {
        console.log("AdminPage: Загрузка данных...")
        if (departmentVm) departmentVm.load()
        if (poVm) poVm.load()
    }

    function updateStatus() {
        console.log("AdminPage: updateStatus вызван")
        
        if (poVm) {
            var newIsPoLoaded = !poVm.isLoading
            if (isPoLoaded !== newIsPoLoaded) {
                isPoLoaded = newIsPoLoaded
            }
            
            if (poVm.programs !== undefined && poVm.programs !== null) {
                var newHasSoftware = Array.isArray(poVm.programs) && poVm.programs.length > 0
                if (hasSoftware !== newHasSoftware) {
                    hasSoftware = newHasSoftware
                }
            } else {
                if (hasSoftware !== false) {
                    hasSoftware = false
                }
            }
        }
        
        if (departmentVm) {
            var newIsDepartmentsLoaded = !departmentVm.isLoading
            if (isDepartmentsLoaded !== newIsDepartmentsLoaded) {
                isDepartmentsLoaded = newIsDepartmentsLoaded
            }
            
            if (departmentVm.departments !== undefined && departmentVm.departments !== null) {
                var newHasDepartments = Array.isArray(departmentVm.departments) && departmentVm.departments.length > 0
                if (hasDepartments !== newHasDepartments) {
                    hasDepartments = newHasDepartments
                }
            } else {
                if (hasDepartments !== false) {
                    hasDepartments = false
                }
            }
        }
    }

    header: ToolBar {
        Material.foreground: "white"
        Material.background: "#2196F3"

        RowLayout {
            anchors.fill: parent
            spacing: 16

            ToolButton {
                text: "☰"
                font.pixelSize: 24
                onClicked: {
                    if (appWindow && appWindow.globalDrawer) {
                        appWindow.globalDrawer.open()
                    }
                }
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
                visible: adminVm.isLoading
                running: visible
                Material.accent: "white"
            }

            ToolButton {
                text: "⟳"
                font.pixelSize: 20
                onClicked: {
                    console.log("AdminPage: Обновление данных")
                    refreshData()
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 320
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                RowLayout {
                    spacing: 8

                    Label {
                        text: "➕"
                        font.pixelSize: 20
                    }

                    Label {
                        text: "Массовое добавление ПК"
                        font.bold: true
                        font.pixelSize: 16
                        color: "#2196F3"
                        Layout.fillWidth: true
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    visible: !isPoLoaded || !isDepartmentsLoaded
                    
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 10
                        
                        BusyIndicator {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            running: true
                            Material.accent: "#2196F3"
                        }
                        
                        Label {
                            text: "Загрузка данных..."
                            color: "#666"
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    visible: isPoLoaded && isDepartmentsLoaded

                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Label {
                            text: "Выберите отделы:"
                            font.pixelSize: 14
                            font.bold: true
                            color: "#424242"
                        }

                        Frame {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            padding: 0
                            background: Rectangle {
                                color: departmentsCombo.enabled ? "#FFFFFF" : "#FAFAFA"
                                border.color: departmentsCombo.enabled ? "#E0E0E0" : "#F0F0F0"
                                radius: 4
                            }
                            
                            ComboBox {
                                id: departmentsCombo
                                anchors.fill: parent
                                anchors.margins: 8
                                enabled: hasDepartments && departmentVm.departments.length > 0
                                Material.accent: "#2196F3"
                                
                                displayText: currentIndex === -1 ? "Выберите отделы" : currentText
                                
                                model: hasDepartments ? departmentVm.departments : []
                                textRole: "name"
                                valueRole: "id"
                                
                                function clearSelection() {
                                    currentIndex = -1
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Label {
                            text: "Количество ПК:"
                            font.pixelSize: 14
                            font.bold: true
                            color: "#424242"
                        }

                        SpinBox {
                            id: pcsCount
                            Layout.fillWidth: true
                            from: 1
                            to: 100
                            value: 1
                            Material.accent: "#2196F3"
                        }
                    }

                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Label {
                            text: "Выберите ПО:"
                            font.pixelSize: 14
                            font.bold: true
                            color: "#424242"
                        }

                        Frame {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            padding: 0
                            background: Rectangle {
                                color: poCombo.enabled ? "#FFFFFF" : "#FAFAFA"
                                border.color: poCombo.enabled ? "#E0E0E0" : "#F0F0F0"
                                radius: 4
                            }
                            
                            ComboBox {
                                id: poCombo
                                anchors.fill: parent
                                anchors.margins: 8
                                enabled: hasSoftware && poVm.programs.length > 0
                                Material.accent: "#2196F3"
                                
                                displayText: currentIndex === -1 ? "Выберите ПО" : currentText
                                
                                model: hasSoftware ? poVm.programs : []
                                textRole: "name"
                                valueRole: "id"
                                
                                function clearSelection() {
                                    currentIndex = -1
                                }
                            }
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        text: "Нет доступного ПО"
                        color: "#FF6B6B"
                        font.pixelSize: 13
                        visible: isPoLoaded && !hasSoftware
                    }
                    
                    Label {
                        Layout.fillWidth: true
                        text: "Нет доступных отделов"
                        color: "#FF6B6B"
                        font.pixelSize: 13
                        visible: isDepartmentsLoaded && !hasDepartments
                    }

                    Button {
                        id: addButton
                        text: "Добавить ПК"
                        Layout.alignment: Qt.AlignRight
                        Material.background: "#2196F3"
                        Material.foreground: "white"
                        padding: 12
                        font.pixelSize: 14
                        font.bold: true
                        implicitWidth: 200

                        enabled: hasSoftware && hasDepartments && 
                                 pcsCount.value > 0 && 
                                 departmentsCombo.currentIndex !== -1 &&
                                 poCombo.currentIndex !== -1

                        onClicked: {
                            console.log("AdminPage: Нажата кнопка 'Добавить ПК'")
                            
                            var selectedDepartmentId = departmentsCombo.currentValue
                            
                            console.log("AdminPage: Выбран отдел ID:", selectedDepartmentId,
                                      "Количество ПК:", pcsCount.value, 
                                      "ПО ID:", poCombo.currentValue)
                            
                            adminVm.bulkAdd([selectedDepartmentId], pcsCount.value, poCombo.currentValue)
                            
                            refreshTimer.start()
                        }
                    }
                }
            }
        }

        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            visible: isPoLoaded && !hasSoftware
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                RowLayout {
                    spacing: 8
                    
                    Label {
                        text: "⚠️"
                        font.pixelSize: 20
                    }
                    
                    Label {
                        text: "Требуется программное обеспечение"
                        font.bold: true
                        color: "#FF9800"
                    }
                }

                Label {
                    text: "Для массового добавления ПК необходимо добавить хотя бы одну программу (ПО) в системе. Перейдите в раздел 'Программное обеспечение' для добавления."
                    wrapMode: Text.WordWrap
                    font.pixelSize: 13
                    color: "#666"
                    Layout.fillWidth: true
                }
            }
        }

        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            visible: isDepartmentsLoaded && !hasDepartments
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                RowLayout {
                    spacing: 8
                    
                    Label {
                        text: "⚠️"
                        font.pixelSize: 20
                    }
                    
                    Label {
                        text: "Требуются отделы"
                        font.bold: true
                        color: "#FF9800"
                    }
                }

                Label {
                    text: "Для массового добавления ПК необходимо иметь хотя бы один отдел в системе. Перейдите в раздел 'Отделы' для добавления."
                    wrapMode: Text.WordWrap
                    font.pixelSize: 13
                    color: "#666"
                    Layout.fillWidth: true
                }
            }
        }
    }

    function handleAdminSuccess(msg) {
        console.log("AdminPage: Успех -", msg)
        showNotification(msg, "success")
        pcsCount.value = 1
        departmentsCombo.clearSelection()
        poCombo.clearSelection()
        refreshTimer.start()
    }
    
    function handleAdminError(msg) {
        console.log("AdminPage: Ошибка -", msg)
        showNotification(msg, "error")
    }
    
    function handlePoError(msg) {
        console.log("AdminPage: Ошибка ПО -", msg)
        showNotification(msg, "error")
        updateStatus()
    }
    
    function handleDepartmentError(msg) {
        console.log("AdminPage: Ошибка отделов -", msg)
        showNotification(msg, "error")
        updateStatus()
    }

    function showNotification(message, type) {
        console.log("Notification [" + type + "]: " + message)
    }
}