import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../components" 1.0
import ViewModels 1.0

Page {
    id: page
    title: "Пользователи"

    property alias userVm: loader.item
    property alias departmentVm: departmentLoader.item
    property alias roleVm: roleLoader.item
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
                visible: userVm ? userVm.isLoading : false
                running: visible
                Material.accent: "white"
            }

            ToolButton {
                text: "⟳"
                font.pixelSize: 20
                onClicked: {
                    userVm.load()
                    departmentVm.load()
                    roleVm.load()
                }
            }
        }
    }

    Loader {
        id: loader
        sourceComponent: UserViewModel {}
        onLoaded: item.load()
    }

    Loader {
        id: departmentLoader
        sourceComponent: DepartmentViewModel {}
        onLoaded: item.load()
    }

    Loader {
        id: roleLoader
        sourceComponent: RoleViewModel {}
        onLoaded: item.load()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        anchors.margins: 16

        Card {
            Layout.fillWidth: true
            Layout.preferredHeight: 240

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                RowLayout {
                    spacing: 8

                    Label {
                        text: "👤"
                        font.pixelSize: 20
                    }

                    Label {
                        text: "Добавить нового пользователя"
                        font.bold: true
                        font.pixelSize: 16
                        color: "#2196F3"
                        Layout.fillWidth: true
                    }
                }

                GridLayout {
                    columns: 2
                    columnSpacing: 16
                    rowSpacing: 12
                    Layout.fillWidth: true

                    Label {
                        text: "Имя пользователя:"
                        font.pixelSize: 14
                    }

                    TextField {
                        id: userNameField
                        Layout.fillWidth: true
                        placeholderText: "Введите имя пользователя"
                        Material.accent: "#2196F3"
                    }

                    Label {
                        text: "Отдел:"
                        font.pixelSize: 14
                    }

                    ComboBox {
                        id: userDepartmentComboBox
                        Layout.fillWidth: true
                        textRole: "text"
                        valueRole: "value"
                        Material.accent: "#2196F3"

                        model: ListModel {
                            id: userDepartmentModel
                        }
                    }

                    Label {
                        text: "Роль:"
                        font.pixelSize: 14
                    }

                    ComboBox {
                        id: userRoleComboBox
                        Layout.fillWidth: true
                        textRole: "text"
                        valueRole: "value"
                        Material.accent: "#2196F3"

                        model: ListModel {
                            id: userRoleModel
                        }
                    }
                }

                Button {
                    text: "Добавить пользователя"
                    enabled: userNameField.text.trim() !== "" && 
                             userDepartmentComboBox.currentIndex >= 0 &&
                             userRoleComboBox.currentIndex >= 0
                    Material.background: "#2196F3"
                    Material.foreground: "white"
                    Layout.alignment: Qt.AlignRight

                    onClicked: {
                        userVm.addUser(userNameField.text.trim(), 
                                      userDepartmentComboBox.currentValue,
                                      userRoleComboBox.currentValue)
                        userNameField.clear()
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
                text: "Список пользователей"
                font.bold: true
                font.pixelSize: 18
                color: "#424242"
                Layout.fillWidth: true
            }

            Label {
                text: userVm ? userVm.users.length : 0
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
                model: userVm ? userVm.users : []
                spacing: 12
                clip: true

                delegate: Card {
                    width: listView.width - 32
                    height: 200 

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
                                    text: "👤"
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
                                        text: "ID: " + modelData.id
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

                                    Label {
                                        text: "•"
                                        font.pixelSize: 12
                                        color: "#BDBDBD"
                                    }

                                    Label {
                                        text: "Роль: " + getRoleName(modelData.roleId)
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
                                    deleteDialog.userId = modelData.id
                                    deleteDialog.userName = modelData.name
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
                    text: userVm && userVm.isLoading ? "Загрузка пользователей..." : "Пользователи не найдены"
                    font.pixelSize: 16
                    color: "#9E9E9E"
                    anchors.centerIn: parent
                }
            }
        }
    }

    Dialog {
        id: deleteDialog
        property int userId: -1
        property string userName: ""

        title: "Удаление пользователя"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Yes | Dialog.No
        width: 400

        ColumnLayout {
            width: parent.width
            spacing: 12

            Label {
                text: "Вы уверены, что хотите удалить пользователя \"" + deleteDialog.userName + "\"?"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
            }

            Label {
                text: "Все данные пользователя будут удалены."
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                color: "#2196F3"
            }
        }

        onAccepted: {
            if (userVm) {
                userVm.deleteUser(userId)
            }
        }
    }

    function getDepartmentName(departmentId) {
        if (!departmentVm || !departmentVm.departments) return "Неизвестно";
        
        for (var i = 0; i < departmentVm.departments.length; i++) {
            var dept = departmentVm.departments[i];
            if (dept && dept.id === departmentId) {
                return dept.name;
            }
        }
        return "Отдел ID:" + departmentId;
    }

    function getRoleName(roleId) {
        if (!roleVm || !roleVm.roles) return "Неизвестно";
        
        for (var i = 0; i < roleVm.roles.length; i++) {
            var role = roleVm.roles[i];
            if (role && role.id === roleId) {
                return role.name;
            }
        }
        return "Роль ID:" + roleId;
    }

    function updateUserDepartmentModel() {
        userDepartmentModel.clear()
        if (departmentVm && departmentVm.departments) {
            for (var i = 0; i < departmentVm.departments.length; i++) {
                var dept = departmentVm.departments[i]
                userDepartmentModel.append({
                    text: dept.name,
                    value: dept.id
                })
            }
        }
    }

    function updateUserRoleModel() {
        userRoleModel.clear()
        if (roleVm && roleVm.roles) {
            for (var i = 0; i < roleVm.roles.length; i++) {
                var role = roleVm.roles[i]
                userRoleModel.append({
                    text: role.name,
                    value: role.id
                })
            }
        }
    }

    Connections {
        target: departmentVm
        function onDepartmentsChanged() {
            updateUserDepartmentModel()
        }
    }

    Connections {
        target: roleVm
        function onRolesChanged() {
            updateUserRoleModel()
        }
    }

    Connections {
        target: userVm
        function onError(message) {
            showNotification(message, "error")
        }
        function onSuccess(message) {
            showNotification(message, "success")
        }
    }

    Component.onCompleted: {
        console.log("Страница пользователей загружена");
        
        timer.start();
    }

    Timer {
        id: timer
        interval: 300
        running: false
        repeat: false
        onTriggered: {
            console.log("Загружаем данные пользователей...");
            if (loader.item) loader.item.load();
            if (departmentLoader.item) departmentLoader.item.load();
            if (roleLoader.item) roleLoader.item.load();
        }
    }
}