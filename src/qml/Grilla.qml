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

    property var jsonData

    Component.onCompleted: {
        jsonData = JSON.parse(plt.getJson())
        jsonData.days.forEach(function (v, i, a) {
            if (i > 5) {
                return
            }
            var day = i
            v.forEach(function (v,i,a) {
                var mod = week.getDay(day).getMod(v.pos)
                mod.duration = v.duration
                mod.empty = false
            })
            week.getDay(day).updateCells()
        })
    }

    function setJsonMod (day, pos, duration, id) {
        if (day === undefined) return
        if (pos === undefined) return
        if (duration === undefined) return
        if (id === undefined) return

        console.log(day, pos, duration, id)
        var d = jsonData.days[day]
        var exists = false
        var mod

        for (var i in d) {
            if (i.positon === pos) {
                i.duration = duration
                i.id = id
                break
            }
        }

        if (!exists) {
            mod = d.push({"id":id,"pos":pos,"duration":duration})
        }
        plt.setJson(JSON.stringify(jsonData))
    }

    ColumnLayout {
        RowLayout {
            Layout.fillWidth: true
            RoundButton {
                font.family: "Material Icons"
                font.pixelSize: 24
                text: Icons.list.menu
                flat: true
                onPressed: menu.popup()
                Menu {
                    id: menu
                    MenuItem { text: "Importar" }
                    MenuItem { text: "Exportar" }
                    MenuItem { text: "Editar" }
                }
            }
            Label {
                text: ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"][swip.currentIndex]
                font.pointSize: 16
                font.bold: true
            }
            Item {
                Layout.fillWidth: true
            }
            RoundButton {
                font.family: "Material Icons"
                font.pixelSize: 24
                text: Icons.list.arrow_back
                flat: true
                onPressed: swip.decrementCurrentIndex()
            }
            RoundButton {
                font.family: "Material Icons"
                font.pixelSize: 24
                text: Icons.list.today
                flat: true
                onPressed: swip.currentIndex = swip.today()
            }
            RoundButton {
                font.family: "Material Icons"
                font.pixelSize: 24
                text: Icons.list.arrow_forward
                flat: true
                onPressed: swip.incrementCurrentIndex()
            }
        }


        anchors.fill: parent
        RowLayout {
            Layout.fillHeight: true
            ColumnLayout {
                Layout.topMargin: -8
                Layout.bottomMargin: -8
                spacing: 0
                Layout.fillHeight: true
                Repeater {
                    model: table.rows
                    Label {
                        Layout.fillHeight: true
                        text: jsonData.moduleText[index] + "  »  "
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
                    id: week

                    function getDay(n) {
                        return itemAt(n)
                    }

                    ColumnLayout {
                        spacing: 0
                        id: day

                        function dayNumber() {
                            return index
                        }

                        function getMod(n) {
                            return repeat.itemAt(n)
                        }
                        function updateCells(i, d) {
                            repeat.updateCells(i, d)
                        }

                        Repeater {
                            id: repeat
                            model: table.rows
                            function updateCells(i, d) {
                                console.log("i:", i, "d:", d)

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

                                setJsonMod(day.dayNumber(), i, d, 0)
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

