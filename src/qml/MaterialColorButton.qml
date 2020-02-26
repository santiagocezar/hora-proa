import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Button {
    readonly property var __colors: [
        Material.Red,
        Material.Purple,
        Material.DeepPurple,
        Material.Blue,
        Material.Cyan,
        Material.Teal,
        Material.Green,
        Material.Amber,
        Material.Orange,
        Material.Grey,
    ]

    property int __colorIndex: 0
    property int color: __colors[__colorIndex]
    Material.background: color

    onClicked: {
        __colorIndex = (__colorIndex + 1) % __colors.length
    }
}
