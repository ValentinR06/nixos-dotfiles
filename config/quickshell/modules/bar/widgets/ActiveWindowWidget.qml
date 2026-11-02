import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs

Item {
  implicitWidth: text.width + 20
  implicitHeight: text.height

  property string title: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""

  Text {
    id: text
    anchors.centerIn: parent

    text: title
    font { 
      pixelSize: Colors.fontSize; 
      family: Colors.fontFamily
      bold: true 
    }
    color: Colors.fg
  }
}