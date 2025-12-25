import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "components" 1.0
import ViewModels 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 1400
    height: 900
    title: "Управление ПО и ПК"
    Material.theme: Material.Light
    Material.accent: Material.Blue
    Material.primary: Material.Blue
    property alias globalDrawer: drawer  
    //property string serverUrl: "http://localhost:8081"
    //property bool isConnected: false

    property color primaryColor: "#2196F3"
    property color secondaryColor: "#03A9F4"
    property color successColor: "#4CAF50"
    property color errorColor: "#F44336"
    property color warningColor: "#FF9800"
    property color backgroundColor: "#F5F5F5"

    FontLoader { id: regularFont; source: "qrc:/qml/fonts/Roboto-Regular.ttf" }
    FontLoader { id: mediumFont; source: "qrc:/qml/fonts/Roboto-Medium.ttf" }
    FontLoader { id: boldFont; source: "qrc:/qml/fonts/Roboto-Bold.ttf" }

    Drawer {
        id: drawer
        width: 300
        height: window.height
        edge: Qt.LeftEdge
        dim: true
        dragMargin: 10

        background: Rectangle {
            color: "white"
            border.color: "#E0E0E0"
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 160
                color: primaryColor

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12

                    Label { 
                        text: "💻"; 
                        font.pixelSize: 40; 
                        Layout.alignment: Qt.AlignHCenter 
                    }
                    Label { 
                        text: "Управление ПО"; 
                        font.pixelSize: 20; 
                        font.bold: true; 
                        font.family: boldFont.name; 
                        color: "white"; 
                        Layout.alignment: Qt.AlignHCenter 
                    }
                    Label { 
                        text: serverUrl; 
                        font.pixelSize: 12; 
                        color: "white"; 
                        opacity: 0.8; 
                        Layout.alignment: Qt.AlignHCenter 
                    }
                }
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    width: parent.width
                    spacing: 4
                    anchors.margins: 16

                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "📁 Категории ПО"; 
                        onClicked: { 
                            stackView.push("qml/CategoriesPage.qml"); 
                            drawer.close() 
                        } 
                    }
                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "🏢 Отделы"; 
                        onClicked: { 
                            stackView.push("qml/DepartmentsPage.qml"); 
                            drawer.close() 
                        } 
                    }
                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "💻 Программы"; 
                        onClicked: { 
                            stackView.push("qml/PoPage.qml"); 
                            drawer.close() 
                        } 
                    }
                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "🖥️ Компьютеры"; 
                        onClicked: { 
                            stackView.push("qml/PcPage.qml"); 
                            drawer.close() 
                        } 
                    }
                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "👤 Пользователи"; 
                        onClicked: { 
                            stackView.push("qml/UsersPage.qml"); 
                            drawer.close() 
                        } 
                    }
                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "👥 Роли"; 
                        onClicked: { 
                            stackView.push("qml/RolesPage.qml"); 
                            drawer.close() 
                        } 
                    }
                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "📦 Установки ПО"; 
                        onClicked: { 
                            stackView.push("qml/SemiPage.qml"); 
                            drawer.close() 
                        } 
                    }
                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "🔄 Версии ПО"; 
                        onClicked: { 
                            stackView.push("qml/VersionPoPage.qml"); 
                            drawer.close() 
                        } 
                    }
                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "📊 Статистика"; 
                        onClicked: { 
                            stackView.push("qml/ReportsPage.qml"); 
                            drawer.close() 
                        } 
                    }
                    /*MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "⚙️ Администрирование"; 
                        onClicked: { 
                            stackView.push("qml/AdminPage.qml"); 
                            drawer.close() 
                        } 
                    }*/

                    Item { Layout.fillHeight: true }

                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "ℹ️ О программе"; 
                        onClicked: { 
                            aboutDialog.open(); 
                            drawer.close() 
                        } 
                    }
                    
                    MenuButton { 
                        fontFamily: mediumFont.name; 
                        primaryColor: primaryColor; 
                        buttonText: "🚪 Выход"; 
                        onClicked: { 
                            Qt.quit();
                        } 
                    }
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainPage
        focus: false
    }

    Component {
        id: mainPage
        Page {
            background: Rectangle { color: backgroundColor }

            Button {
                text: "☰ МЕНЮ"
                onClicked: drawer.open()
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                z: 1000
                
                Material.background: primaryColor
                Material.foreground: "white"
                font.family: mediumFont.name
                font.pixelSize: 14
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.Material.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                background: Rectangle {
                    radius: 6
                    color: parent.Material.background
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 40
                width: Math.min(parent.width * 0.8, 800)

                ColumnLayout {
                    spacing: 16
                    Layout.alignment: Qt.AlignHCenter

                    Label {
                        text: "💻"
                        font.pixelSize: 64
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Label {
                        text: "Добро пожаловать"
                        font.pixelSize: 32
                        font.bold: true
                        font.family: boldFont.name
                        color: primaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Label {
                        text: "Система управления программным обеспечением\nи компьютерной техникой"
                        font.pixelSize: 16
                        color: "#757575"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    radius: 8
                    color: "#E3F2FD"
                    border.color: "#90CAF9"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16

                        Label {
                            text: "💡"
                            font.pixelSize: 24
                        }

                        Label {
                            text: "Нажмите кнопку МЕНЮ в левом верхнем углу для навигации\nИспользуйте клавишу ESC, Back или кнопку Назад для открытия меню"
                            font.pixelSize: 14
                            color: "#1976D2"
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            font.family: regularFont.name
                        }
                    }
                }
            }
            
            Button {
                text: "← Назад"
                visible: stackView.depth > 1
                onClicked: {
                    if (drawer.opened) {
                        drawer.close()
                    } else {
                        drawer.open()
                    }
                }
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 10
                z: 1000
                
                Material.background: secondaryColor
                Material.foreground: "white"
                font.family: mediumFont.name
                font.pixelSize: 14
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: parent.Material.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                background: Rectangle {
                    radius: 6
                    color: parent.Material.background
                }
            }
        }
    }

    Dialog {
        id: aboutDialog
        title: "О программе"
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Close
        width: 400
        height: 300

        ColumnLayout {
            width: parent.width
            spacing: 16

            Label { 
                text: "💻"; 
                font.pixelSize: 48; 
                Layout.alignment: Qt.AlignHCenter 
            }
            Label { 
                text: "Управление ПО и ПК"; 
                font.pixelSize: 24; 
                font.bold: true; 
                font.family: boldFont.name; 
                Layout.alignment: Qt.AlignHCenter 
            }
            Label { 
                text: "Версия 1.0.0"; 
                font.pixelSize: 14; 
                color: "#757575"; 
                Layout.alignment: Qt.AlignHCenter 
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: "#E0E0E0"
            }
            Label { 
                text: "Клиент для системы управления программным\nобеспечением и компьютерной техникой"; 
                font.pixelSize: 14; 
                wrapMode: Text.WordWrap; 
                horizontalAlignment: Text.AlignHCenter; 
                Layout.fillWidth: true;
                font.family: regularFont.name;
            }
        }
    }

    QtObject {
        id: connectionManager
        function checkConnection() {
            var testUrl = serverUrl + "/categories"
            console.log("Проверка соединения с:", testUrl)
            isConnected = Math.random() > 0.5

            if (isConnected) {
                console.log("Соединение установлено успешно")
            } else {
                console.log("Не удалось подключиться к серверу")
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+M"
        onActivated: drawer.open()
    }
    
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (drawer.opened) {
                drawer.close()
            } else if (aboutDialog.opened) {
                aboutDialog.close()
            } else {
                drawer.open()
            }
        }
    }
    
    Shortcut {
        sequence: "Back"
        onActivated: {
            if (drawer.opened) {
                drawer.close()
            } else if (aboutDialog.opened) {
                aboutDialog.close()
            } else {
                drawer.open()
            }
        }
    }
    
    Shortcut {
        sequence: "F1"
        onActivated: aboutDialog.open()
    }

    Component.onCompleted: {
        console.log("Приложение запущено")
        console.log("Сервер:", serverUrl)
        
        connectionManager.checkConnection()
    }
}