import QtQuick 2.12

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import QtQuick.Layouts 1.12

import "tools.js" as Tools
import "icons.js" as Icons

ApplicationWindow {
    visible: true
    width: 840
    height: 640
    title: qsTr("Hello World")

    Material.theme: Material.Light
    Material.accent: Material.Blue
    Material.primary: Material.background

    header: ToolBar {
        TabBar {
            id: tabs
            width: parent.width
            TabButton {
                text: "Planilla"
            }
            TabButton {
                text: "Materias"
            }
            Material.background: Material.primary

        }
    }

    SwipeView {
        anchors.fill: parent
        currentIndex: tabs.currentIndex

        onCurrentIndexChanged: {
            tabs.currentIndex = currentIndex
        }

        Item {
            Grilla {
                id: table
                anchors.fill: parent
                anchors.margins: 16
            }
        }

        Item {
            Materias {
                id: materias
                anchors.fill: parent
                anchors.margins: 16
            }
        }

    }

}
