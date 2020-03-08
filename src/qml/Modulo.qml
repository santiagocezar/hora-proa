import QtQuick 2.12

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import QtQuick.Layouts 1.12

import "tools.js" as Tools

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

        Material.background: empty ? Material.backgroundColor : module.color

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

        onClicked: module.clicked()
    }

}

