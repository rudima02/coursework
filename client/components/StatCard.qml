import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property string title: ""
    property string value: "0"
    property string icon: ""
    property color textColor: "#2196F3"
    
    width: 120
    height: 100
    
    Rectangle {
        anchors.fill: parent
        radius: 8
        color: "white"
        border.color: "#E0E0E0"
        border.width: 1
        
        Column {
            spacing: 8
            anchors.centerIn: parent
            
            Label {
                text: icon
                font.pixelSize: 24
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Label {
                text: value
                font.pixelSize: 24
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                color: textColor
            }
            
            Label {
                text: title
                font.pixelSize: 12
                color: "#757575"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}