import QtQuick 2.12

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import QtQuick.Layouts 1.12

import "tools.js" as Tools
import "icons.js" as Icons

Item {
    id: materias
    
    ScrollView {
        anchors.fill: parent
        ColumnLayout {
            implicitWidth: materias.width
            Repeater {
                model: 30
                MateriaCard {
                    implicitHeight: 48
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
