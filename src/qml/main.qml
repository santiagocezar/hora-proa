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
    title: qsTr("HoraProA")

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
        id: swipe
        anchors.fill: parent
        currentIndex: tabs.currentIndex

        onCurrentIndexChanged: {
            tabs.currentIndex = currentIndex

            if (currentIndex == 0) { // operation canceled
                table.selecting = false
                materias.selectMode = false
            }
        }

        Item {
            Grilla {
                id: table
                anchors.fill: parent
                anchors.margins: 16
                onSelectingChanged: {
                    if (selecting) {
                        materias.selectMode = true
                        swipe.incrementCurrentIndex()
                    }
                }
            }
        }

        Item {
            Materias {
                id: materias
                anchors.fill: parent
                onSelected: function (id, duration) {
                    table.selected(id, duration)
                    swipe.decrementCurrentIndex()
                    selectMode = false
                }
            }
        }

    }

}
