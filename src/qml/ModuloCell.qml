import QtQuick 2.0

Modulo {
    property ModuloCell before1
    property ModuloCell before2

    Component.onCompleted: {
        if (before1 !== null) {
            before1.onDurationChanged = function () {
                if (!empty) {
                    before1.duration -= 1
                }
                else {
                    visible = before1.duration != 2
                }
            }
        }
        if (before2 !== null) {
            before2.onDurationChanged = function () {
                if (!empty && before1.duration == 3) {
                    before1.duration -= 1
                }
                else {
                    visible = before1.duration != 3
                }
            }
        }
    }

}
