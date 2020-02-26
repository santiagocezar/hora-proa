import QtQuick 2.12

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import QtQuick.Layouts 1.12

import "tools.js" as Tools
import "icons.js" as Icons

Item {

    id: table
    readonly property int columns: 6
    readonly property int rows: 14
    
    ColumnLayout {
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"][swip.currentIndex]
                font.pointSize: 16
                font.bold: true
            }
            Item {
                Layout.fillWidth: true
            }
            Button {
                font.family: "Material Icons"
                font.pixelSize: 24
                text: Icons.list.arrow_back
                implicitWidth: height
                flat: true
                onPressed: swip.decrementCurrentIndex()
            }
            Button {
                font.family: "Material Icons"
                font.pixelSize: 24
                text: Icons.list.today
                implicitWidth: height
                flat: true
                onPressed: swip.currentIndex = swip.today()
            }
            Button {
                font.family: "Material Icons"
                font.pixelSize: 24
                text: Icons.list.arrow_forward
                implicitWidth: height
                flat: true
                onPressed: swip.incrementCurrentIndex()
            }
        }


        anchors.fill: parent
        RowLayout {
            Layout.fillHeight: true
            ColumnLayout {
                Layout.fillHeight: true
                Repeater {
                    model: table.rows
                    Label {
                        Layout.fillHeight: true
                        readonly property int minutes: (index * 40) + (Math.floor(index / 2) * 10) + (index > 5 ? -5 : 0) + (index > 7 ? -10 : 0)
                        //text: "hola"
                        text: Tools.minutesToTime(minutes + 30 + 7 * 60) + " a " + Tools.minutesToTime(minutes + 30 + 7 * 60 + 40) + "   |   "
                        verticalAlignment: Qt.AlignVCenter
                        color: Material.backgroundDimColor
                    }
                }
            }

            SwipeView {
                id: swip
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: -8
                Layout.bottomMargin: -8
                property date now: new Date()
                currentIndex: today()
                clip: true

                function today() {
                    var i = Math.max(0, now.getDay() - 1)
                    if (i > 4) i = 0
                    return i
                }

                Repeater {
                    model: table.columns - 1
                    Item {
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0
                            id: day

                            Repeater {
                                id: repeat
                                model: table.rows
                                function updateCells(i, d) {
                                    console.log(i)

                                    for (var j = 1; j < d; j++) {
                                        try {
                                            if (!itemAt(i+j).empty) {
                                                itemAt(i).duration = j
                                                d = j
                                                break
                                            }
                                        }
                                        catch(err) {
                                            if (err instanceof TypeError) {
                                                itemAt(i).duration = j
                                                d = j
                                                break
                                            }
                                        }

                                    }

                                    for (j = 1; j < d; j++) {
                                        itemAt(i+j).visible = false
                                    }
                                    for (j = d; j < 3; j++) {
                                        itemAt(i+j).visible = true
                                    }
                                }

                                Modulo {
                                    rowHeight: day.height / table.rows
                                    Layout.fillWidth: true
                                    onModified: repeat.updateCells(i, d)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

