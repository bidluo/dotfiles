import QtQuick
import Quickshell
import qs.Common
import qs.Modules.Plugins
import qs.Services
import qs.Widgets

PluginComponent {
    id: root

    readonly property real usage: DgopService.cpuUsage
    readonly property real temp: DgopService.cpuTemperature

    readonly property color usageColor: {
        if (root.usage > 80) {
            return Theme.tempDanger;
        }

        if (root.usage > 60) {
            return Theme.tempWarning;
        }

        return Theme.widgetIconColor;
    }

    readonly property color tempColor: {
        if (root.temp > 85) {
            return Theme.tempDanger;
        }

        if (root.temp > 69) {
            return Theme.tempWarning;
        }

        return Theme.widgetTextColor;
    }

    readonly property real textSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)

    readonly property string usageText: (root.usage === undefined || root.usage === null) ? "--%" : root.usage.toFixed(0) + "%"
    readonly property string tempText: (root.temp === undefined || root.temp === null || root.temp <= 0) ? "--°" : Math.round(root.temp) + "°"

    Component.onCompleted: DgopService.addRef(["cpu"])
    Component.onDestruction: DgopService.removeRef(["cpu"])

    pillClickAction: function () {
        DgopService.setSortBy("cpu");
        Quickshell.execDetached(["dms", "ipc", "call", "processlist", "toggle"]);
    }

    horizontalBarPill: Component {
        Row {
            anchors.centerIn: parent
            spacing: Theme.spacingXS

            DankIcon {
                name: "memory"
                size: root.iconSizeLarge
                color: root.usageColor
                anchors.verticalCenter: parent.verticalCenter
            }

            StatValue {
                anchors.verticalCenter: parent.verticalCenter
                baselineText: "100%"
                fontPixelSize: root.textSize
                text: root.usageText
                color: Theme.widgetTextColor
            }

            Rectangle {
                width: 1
                height: root.iconSizeLarge * 0.7
                color: Theme.outlineButton
                anchors.verticalCenter: parent.verticalCenter
            }

            StatValue {
                anchors.verticalCenter: parent.verticalCenter
                baselineText: "100°"
                fontPixelSize: root.textSize
                text: root.tempText
                color: root.tempColor
            }
        }
    }

    verticalBarPill: Component {
        Column {
            anchors.centerIn: parent
            spacing: 1

            DankIcon {
                name: "memory"
                size: root.iconSizeLarge
                color: root.usageColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                text: root.usageText.replace("%", "")
                font.pixelSize: root.textSize
                color: Theme.widgetTextColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                text: root.tempText
                font.pixelSize: root.textSize
                color: root.tempColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
