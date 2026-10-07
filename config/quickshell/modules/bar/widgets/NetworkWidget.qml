import Quickshell
import QtQuick 
import QtQuick.Layouts
import qs

Item {
  readonly property string icon: {
    if (NetworkConnection.ethernetConnected) return String.fromCodePoint(0xf0200)
    if (NetworkConnection.wifiConnected) {
      if (NetworkConnection.wifiStrength >= 80) return String.fromCodePoint(0xf0928)
      if (NetworkConnection.wifiStrength >= 60) return String.fromCodePoint(0xf0925)
      if (NetworkConnection.wifiStrength >= 40) return String.fromCodePoint(0xf0922)
      if (NetworkConnection.wifiStrength >= 20) return String.fromCodePoint(0xf091f)
      return String.fromCodePoint(0xf092f)
    } else {
      return String.fromCodePoint(0xf05aa)
    }
  }

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
      Quickshell.execDetached(["kitty", "--", "wlctl"])
    }
  }
}


