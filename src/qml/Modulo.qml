import QtQuick 2.12

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import QtQuick.Layouts 1.12

import "tools.js" as Tools

Item {
    id: module

    signal modified(int i, int d)

    property int duration: 1
    property bool empty: true
    property int rowHeight
    implicitHeight: rowHeight * duration - anchors.margins * 2 * duration

    Pane {
        id: card

        Material.elevation: 1

        anchors.fill: parent
        anchors.margins: 4

        property int _color
        Material.background: empty ? Material.backgroundColor : _color

        Label {
            id: displayName
            anchors.fill: parent
            anchors.margins: 5
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
            text: ""
        }

        Dialog {
            anchors.centerIn: overlay
            title: "Agregar materia"
            id: newDialog
            modal: true
            standardButtons: Dialog.Cancel | Dialog.Ok

            implicitWidth: 360

            ColumnLayout {
                anchors.fill: parent
                TextField {
                    Layout.alignment: Qt.AlignHCenter
                    id: name
                    placeholderText: "Nombre"
                    Keys.onReturnPressed: newDialog.accept()
                }
                SpinBox {
                    id: durationSpin
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: 240
                    from: 1; to: 3
                    textFromValue: function(v) {
                        return ["Medio modulo", "Un modulo", "Modulo y medio"][v - 1]
                    }
                }
                MaterialColorButton {
                    id: colorButton
                    text: "Cambiar color"
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            onAccepted: {
                displayName.text = name.text
                module.duration = durationSpin.value
                module.empty = false
                card._color = colorButton.color
                module.modified(index, module.duration)
            }
        } // Dialogo Añadir materia

        Dialog {
            anchors.centerIn: overlay
            title: displayName.text
            id: classDialog
            modal: true
            standardButtons: Dialog.Cancel | Dialog.Ok

            implicitWidth: 360

        } // Dialogo Materia
    }

    MouseArea {
        anchors.fill: card

        onClicked: {
            console.log(width, height)
            newDialog.open()
        }
    }


}

