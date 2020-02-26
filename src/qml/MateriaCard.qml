import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import "icons.js" as Icons

Pane {
    Material.elevation: 2
    RowLayout {
        anchors.fill: parent
        Label {
            font.pixelSize: 24
            text: "Ejemplo"
        }
        Item { Layout.fillWidth: true }

        RowLayout {
            Layout.alignment: Qt.AlignBottom
            Label {
                font.family: "Material Icons"
                font.pixelSize: 24
                text: Icons.list.book
            }
            Label {
                font.family: "Material Icons"
                font.pixelSize: 24
                text: Icons.list.assignment
            }
            Label {
                text: "3"
                font.bold: true
            }
        }
    }

}
