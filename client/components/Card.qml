import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15  

Rectangle {
    id: card
    
    property int padding: 16
    property alias contentItem: contentLoader.item
    
    radius: 8
    color: "white"
    border.color: "#E0E0E0"
    border.width: 1
    
    Loader {
        id: contentLoader
        anchors.fill: parent
        anchors.margins: card.padding
    }
}