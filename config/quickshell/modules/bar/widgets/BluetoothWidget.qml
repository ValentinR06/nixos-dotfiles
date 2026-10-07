import Quickshell
import QtQuick
import QtQuick.Layouts
import qs

Item {
  implicitWidth: text.width
  implicitHeight: text.height
  Text {
    id : text

    font {
      pixelSize: Colors.fontSize;
      family: Colors.fontFamily
      weight: Font.Medium
    }
    color: Colors.fg
    text: String.fromCodePoint(0xF00AF)
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
      Quickshell.execDetached(["kitty", "--", "bluetui"])
    }
  }
}