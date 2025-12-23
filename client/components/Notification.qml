import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: notification
    width: 300
    height: 60
    radius: 8
    color: {
        if (type === "success") return "#4CAF50";
        if (type === "error") return "#F44336";
        if (type === "warning") return "#FF9800";
        return "#2196F3";
    }
    border.color: Qt.darker(color, 1.2)
    border.width: 1
    
    property string text: ""
    property string type: "info"
    property alias timeout: hideTimer.interval
    
    visible: false
    
    Text {
        anchors.fill: parent
        anchors.margins: 8
        text: notification.text
        color: "white"
        font.pixelSize: 14
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }
    
    Timer {
        id: hideTimer
        interval: 3000
        onTriggered: notification.hide()
    }
    
    function show() {
        visible = true;
        hideTimer.start();
    }
    
    function hide() {
        visible = false;
        hideTimer.stop();
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: notification.hide()
    }
}