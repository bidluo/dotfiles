import QtQuick
import qs.Common
import qs.Widgets

// Fixed-width numeric readout: reserves room for `baselineText` so the pill
// doesn't jitter as the value changes width.
Item {
    id: root

    property string baselineText: "100%"
    property alias text: label.text
    property alias color: label.color
    property real fontPixelSize: Theme.fontSizeSmall

    implicitWidth: Math.max(baseline.width, current.width)
    implicitHeight: label.implicitHeight

    StyledTextMetrics {
        id: baseline
        font.pixelSize: root.fontPixelSize
        text: root.baselineText
    }

    StyledTextMetrics {
        id: current
        font.pixelSize: root.fontPixelSize
        text: label.text
    }

    StyledText {
        id: label
        anchors.fill: parent
        font.pixelSize: root.fontPixelSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideNone
    }
}
