import Quickshell
import QtQuick
import QtQuick.Layouts
import qs

RowLayout {
  id: root
  spacing: 4

  readonly property string icon: {
    if (Battery.charging) return String.fromCodePoint(0xF0084)
    if (Battery.percentage >= 100) return String.fromCodePoint(0xF0079)
    if (Battery.percentage < 10) return String.fromCodePoint(0xF0083)
    return String.fromCodePoint(0xF007A + (Math.floor(Battery.percentage / 10) - 1))
  }

  Text {
    font {
      pixelSize: Colors.fontSize;
      family: Colors.fontFamily
      weight: Font.Medium
    }
    color: {
      if (Battery.charging || Battery.percentage >= 80) return Colors.success
      if (Battery.percentage < 20) return Colors.critical
      return Colors.warning
    }
    text: root.icon
  }

  Text {
    font {
      pixelSize: Colors.fontSize;
      family: Colors.fontFamily
      weight: Font.Medium
    }
    color: Colors.fg
    text: Battery.percentage + "%"
  }
}

