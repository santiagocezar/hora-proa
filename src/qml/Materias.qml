import QtQuick 2.12

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import QtQuick.Layouts 1.12

import "tools.js" as Tools
import "icons.js" as Icons

Item {
    id: materias

    property bool selectMode: false

    property var jsonData

    signal selected(int id, int duration)

    Component.onCompleted: {
        jsonData = JSON.parse(dta.getJson())

        jsonData.subjects.forEach(function(value, index, a) {
            materiaModel.append({"name": value.name, "col": value.color, "uidL": value.uid})
        })
    }

    ListModel {
        id: materiaModel
    }

    Component {
        id: materiaDelegate
        MateriaCard {
            implicitHeight: 48
            Layout.margins: 8
            Layout.fillWidth: true
            subject: name
            bgColor: Number(col)
            taskNumb: 0
            uid: uidL

            onClicked: {
                if (materias.selectMode)
                    materias.selected(uid, durationSpin.value)
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        RowLayout {
            visible: materias.selectMode

            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.topMargin: 16
            Layout.bottomMargin: 8

            Label {
                font.pointSize: 16
                font.bold: true
                text: "Seleccione una materia:"
            }

            Item { Layout.fillWidth: true }

            SpinBox {
                id: durationSpin
                implicitWidth: 240
                from: 1; to: 3
                textFromValue: function(v) {
                    return ["Medio modulo", "Un modulo", "Modulo y medio"][v - 1]
                }
            }
        }

        ToolSeparator {
            visible: materias.selectMode

            orientation: Qt.Horizontal
            Layout.fillWidth: true
            Layout.topMargin: -8
            Layout.bottomMargin: -8
        }

        Flickable {

            clip: true

            contentWidth: width
            contentHeight: columns.height

            interactive: true

            Layout.fillHeight: true
            Layout.fillWidth: true

            ScrollBar.vertical: ScrollBar {}
            boundsBehavior: Flickable.StopAtBounds

            ColumnLayout {
                width: parent.width
                spacing: -8
                id: columns
                Repeater {
                    model: materiaModel
                    delegate: materiaDelegate
                }
            }
        }
    }


    
    RoundButton {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        height: 56
        width: height
        font.family: "Material Icons"
        font.pixelSize: 24
        Material.background: Material.backgroundColor
        Material.foreground: Material.accent
        text: Icons.list.add

        onClicked: newDialog.open()

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
                MaterialColorButton {
                    id: colorButton
                    text: "Cambiar color"
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            onAccepted: {
                var uid = dta.subjectUID()
                materiaModel.append({"name": name.text, "col": colorButton.color.toString(), "uidL": uid})
                jsonData.subjects.push({"name": name.text, "color": colorButton.color.toString(), "uid": uid})
                console.log("Generated UID:", uid)
                dta.setJson(JSON.stringify(jsonData))
            }
        } // Dialogo Añadir materia
    }
}
