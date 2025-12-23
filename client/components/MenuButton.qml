import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Button {
    property alias iconText: iconLabel.text
    property alias buttonText: textLabel.text
    property bool isActive: false

    property string fontFamily: "Roboto-Medium"
    property color primaryColor: "#2196F3"

    Layout.fillWidth: true
    Layout.preferredHeight: 48
    flat: true

    contentItem: RowLayout {
        spacing: 16

        Label {
            id: iconLabel
            font.pixelSize: 20
            Layout.preferredWidth: 24
        }

        Label {
            id: textLabel
            Layout.fillWidth: true
            font.pixelSize: 14
            font.family: fontFamily
        }

        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: primaryColor
            visible: isActive
        }
    }

    background: Rectangle {
        color: parent.hovered ? Qt.rgba(0.1, 0.1, 0.1, 0.05) : "transparent"
        border.color: isActive ? primaryColor : "transparent"
        border.width: 2
        radius: 4
    }
}
