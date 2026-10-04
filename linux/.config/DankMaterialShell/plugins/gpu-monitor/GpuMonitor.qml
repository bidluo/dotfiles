import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Modules.Plugins
import qs.Services
import qs.Widgets

PluginComponent {
    id: root

    property int usage: -1
    property int temp: -1

    readonly property real textSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)

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

    readonly property string usageText: root.usage < 0 ? "--%" : root.usage + "%"
    readonly property string tempText: root.temp < 0 ? "--°" : root.temp + "°"

    pillClickAction: function () {
        Quickshell.execDetached(["dms", "ipc", "call", "processlist", "toggle"]);
    }

    Process {
        id: smiProcess
        command: ["nvidia-smi", "--query-gpu=utilization.gpu,temperature.gpu", "--format=csv,noheader,nounits"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const fields = text.trim().split("\n")[0].split(",");
                const usage = parseInt(fields[0], 10);
                const temp = parseInt(fields[1], 10);
                root.usage = isNaN(usage) ? -1 : usage;
                root.temp = isNaN(temp) ? -1 : temp;
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0) {
                root.usage = -1;
                root.temp = -1;
            }
        }
    }

    Timer {
        interval: 3000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            if (!smiProcess.running) {
                smiProcess.running = true;
            }
        }
    }

    horizontalBarPill: Component {
        Row {
            anchors.centerIn: parent
            spacing: Theme.spacingXS

            DankIcon {
                name: "auto_awesome_mosaic"
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
                name: "auto_awesome_mosaic"
                size: root.iconSizeLarge
                color: root.usageColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                text: root.usage < 0 ? "--" : root.usage.toString()
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
