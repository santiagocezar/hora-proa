import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import "icons.js" as Icons

Pane {
    id: card

    property int bgColor: Material.LightBlue
    property string subject: ""
    property int taskNumb: 0
    property int uid

    Material.elevation: 2
    Material.background: bgColor

    signal clicked()

    MouseArea {
        anchors.fill: parent
        onClicked: card.clicked()
    }

    RowLayout {
        anchors.fill: parent
        Label {
            font.pixelSize: 24
            text: card.subject
        }
        Item { Layout.fillWidth: true }

        RowLayout {
            Layout.alignment: Qt.AlignBottom
            Label {
                font.family: "Material Icons"
                font.pixelSize: 24
                text: Icons.list.assignment
            }
            Label {
                text: card.taskNumb
                font.bold: true
            }
        }
    }

}
