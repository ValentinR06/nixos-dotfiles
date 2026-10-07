import Quickshell
import Quickshell.Hyprland

import QtQuick
import QtQuick.Layouts

import qs

RowLayout {
  Repeater {
    model: 10

    Text {
      property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
      property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
      text: index + 1
      color: isActive ? Colors.accent : (ws !== undefined ? Colors.fg : Colors.surface)
      visible: index < 5 || isActive || ws !== undefined
      font { 
        pixelSize: Colors.fontSize; 
        family: Colors.fontFamily
        bold: true 
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + (index + 1) + " })")
      }
    }
  }
}
