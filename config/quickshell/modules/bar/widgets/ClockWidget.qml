import Quickshell
import QtQuick
import qs

Text {
  font {
    pixelSize: Colors.fontSize;
    family: Colors.fontFamily
    weight: Font.Bold
  }
  color: Colors.fg
  text: Time.time
}

