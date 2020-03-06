import QtQuick 2.12

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import QtQuick.Layouts 1.12

import "tools.js" as Tools
import "icons.js" as Icons

Item {
    id: materias

    Flickable {

        contentWidth: columns.width
        contentHeight: columns.height
        anchors.fill: parent

        ScrollBar.vertical: ScrollBar {}
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            implicitWidth: materias.width
            spacing: -8
            id: columns
            Repeater {
                model: 30
                MateriaCard {
                    implicitHeight: 48
                    Layout.margins: 8
                    Layout.fillWidth: true
                }
            }
        } 
    }
    
    
    RoundButton {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        highlighted: true
        font.family: "Material Icons"
        font.pixelSize: 24
        text: Icons.list.add
    }
}
