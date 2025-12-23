import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15 

Item {
    id: root
    
    property var notifications: []
    property int maxNotifications: 3
    
    width: 400
    height: childrenRect.height
    
    function show(message, type) {
        var notification = {
            message: message,
            type: type,
            id: Math.random().toString(36).substr(2, 9)
        }
        
        notifications.unshift(notification)
        
        if (notifications.length > maxNotifications) {
            notifications.pop()
        }
        
        timer.restart()
    }
    
    Column {
        id: notificationColumn
        width: parent.width
        spacing: 8
        
        Repeater {
            model: notifications
            
            delegate: Rectangle {
                id: notificationDelegate
                width: notificationColumn.width
                height: 60
                radius: 8
                color: getColor(modelData.type)
                opacity: 0.95
                
                property var notificationData: modelData
                
                RowLayout {  
                    anchors.fill: parent
                    anchors.margins: 12
                    
                    Label {
                        text: getIcon(modelData.type)
                        font.pixelSize: 20
                        color: "white"
                        Layout.alignment: Qt.AlignVCenter
                    }
                    
                    Label {
                        text: modelData.message
                        font.pixelSize: 14
                        color: "white"
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                    }
                    
                    Button {
                        text: "✕"
                        font.pixelSize: 12
                        implicitWidth: 30
                        implicitHeight: 30
                        onClicked: {
                            var index = notifications.indexOf(modelData)
                            if (index !== -1) {
                                notifications.splice(index, 1)
                            }
                        }
                        
                        background: Rectangle {
                            color: "transparent"
                        }
                        
                        contentItem: Label {
                            text: parent.text
                            font: parent.font
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var index = notifications.indexOf(modelData)
                        if (index !== -1) {
                            notifications.splice(index, 1)
                        }
                    }
                }
                
                NumberAnimation {
                    target: notificationDelegate
                    property: "opacity"
                    from: 0
                    to: 0.95
                    duration: 300
                    running: true
                }
                
                SequentialAnimation {
                    id: removeAnimation
                    running: false
                    
                    NumberAnimation {
                        target: notificationDelegate
                        property: "opacity"
                        to: 0
                        duration: 300
                    }
                    
                    ScriptAction {
                        script: {
                            var index = notifications.indexOf(modelData)
                            if (index !== -1) {
                                notifications.splice(index, 1)
                            }
                        }
                    }
                }
                
                Timer {
                    interval: 5000
                    running: true
                    onTriggered: removeAnimation.start()
                }
            }
        }
    }
    
    Timer {
        id: timer
        interval: 5000
        onTriggered: {
            if (notifications.length > 0) {
                notifications.pop()
            }
        }
    }
    
    function getColor(type) {
        switch(type) {
            case "success": return "#4CAF50"
            case "error": return "#F44336"
            case "warning": return "#FF9800"
            case "info": return "#2196F3"
            default: return "#2196F3"
        }
    }
    
    function getIcon(type) {
        switch(type) {
            case "success": return "✓"
            case "error": return "✗"
            case "warning": return "⚠"
            case "info": return "ℹ"
            default: return "ℹ"
        }
    }
}