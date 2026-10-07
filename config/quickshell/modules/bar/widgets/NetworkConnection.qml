pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Networking

Singleton {
    id: root

    readonly property bool wifiConnected: true
    readonly property int wifiStrength: 80
    readonly property bool ethernetConnected: false 
}