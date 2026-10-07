import Quickshell
import QtQuick.Layouts
import QtQuick
import qs

import "widgets"

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData
      color: Colors.bg

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 32
      Item {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14

        RowLayout {
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter
          
          WorkspaceWidget {
            id: workspaceWidget
          }
        }

        RowLayout {
          anchors.centerIn: parent
          
          ClockWidget {
            id: clockWidget
          }
        }

        RowLayout {
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          spacing: 10

          SoundWidget {
            id: soundWidget
          }          
          
          BluetoothWidget {
            id: bluetoothWidget
          }

          NetworkWidget {
            id: networkWidget
          }

          BatteryWidget {
            id: batteryWidget
          }
        }
      }
    }
  }
}

