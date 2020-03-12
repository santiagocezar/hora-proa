import QtQuick 2.12

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import QtQuick.Layouts 1.12

Item {
    id: module

    signal clicked()

    property int duration: 1
    property string name: ""
    property int color
    property bool empty: true
    property int uid

    property int rowHeight

    implicitHeight: rowHeight * duration - anchors.margins * 2 * duration

    Pane {
        id: card

        Material.elevation: 1

        anchors.fill: parent
        anchors.margins: 4

        Material.background: module.empty ? Material.primary : module.color

        Component.onCompleted: {
            if (!empty) {
                displayName.text = dta.getSubjectName(module.uid)
                card.bgColor = dta.getSubjectColor(module.uid)
            }
        }

        Label {
            id: displayName
            anchors.fill: parent
            anchors.margins: 5
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            text: module.name
        }
    }

    MouseArea { // a lo ultimo porque si no, no se le puede hacer click
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: {
            if (empty && mouse.button & Qt.LeftButton) {
                module.clicked()
            }
            if (!empty && mouse.button & Qt.RightButton) {
                menu.popup()
            }

        }
        onPressAndHold: {
            if (!empty) menu.popup()
        }
    }

    Menu {
        id: menu
        MenuItem {
            text: "Editar"
        }
        MenuItem {
            text: "Borrar"; Material.foreground: Material.Red; font.bold: true
            onClicked: module.empty = true
        }
    }
}

