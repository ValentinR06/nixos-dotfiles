pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.UPower

Singleton {
  id: root

  readonly property bool ready: UPower.displayDevice.ready

  readonly property int percentage: {
    ready ? Math.round(UPower.displayDevice.percentage * 100) : -1
  }

  readonly property bool charging: {
    ready ? UPower.displayDevice.state === UPowerDeviceState.Charging : false
  }
}
