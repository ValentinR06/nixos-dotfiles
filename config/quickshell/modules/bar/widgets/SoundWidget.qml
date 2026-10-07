import Quickshell
import QtQuick.Layouts
import QtQuick
import qs

Item {
  implicitWidth: text.width
  implicitHeight: text.height

  readonly property string icon: {
    if (Sound.isMuted) return String.fromCodePoint(0xeee8)
    if (Sound.volume >= 70) return String.fromCodePoint(0xf028)
    if (Sound.volume >= 30) return String.fromCodePoint(0xefcf)
    if (Sound.volume >= 1) return String.fromCodePoint(0xf027)
    return String.fromCodePoint(0xf026)

  }

  Text {
    id : text

    font {
      pixelSize: Colors.fontSize;
      family: Colors.fontFamily
      weight: Font.Medium
    }
    color: Colors.fg
    text: icon
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onEntered: {
      text.color = Colors.accent
    }
    onExited: {
      text.color = Colors.fg
    }

    onClicked: {

    }
  }
}