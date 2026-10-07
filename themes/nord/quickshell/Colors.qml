pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property string bg: "#2e3440"
  readonly property string bg_dark: "#242933"
  readonly property string surface: "#3b4252"
  readonly property string surface_bright: "#434c5e"
  readonly property string fg: "#d8dee9"
  readonly property string muted: "#4c566a"
  readonly property string accent: "#88c0d0"
  readonly property string accent_alt: "#81a1c1"
  readonly property string success: "#a3be8c"
  readonly property string warning: "#ebcb8b"
  readonly property string critical: "#bf616a"

  readonly property string fontFamily: "JetBrainsMono Nerd Font"
  readonly property int fontSize: 14
}
