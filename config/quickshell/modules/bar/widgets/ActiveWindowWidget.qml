import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs

Text {
    id: text
    text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
    font {
      pixelSize: Colors.fontSize;
      family: Colors.fontFamily
      weight: Font.Medium
    }
    color: Colors.fg
}