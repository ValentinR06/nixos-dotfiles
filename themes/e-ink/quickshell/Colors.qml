pragma Singleton

import Quickshell
import QtQuick

Singleton {
  readonly property string bg: "#ffffff"
  readonly property string bg_dark: "#f5f5f5"
  readonly property string surface: "#e0e0e0"
  readonly property string surface_bright: "#cccccc"
  readonly property string fg: "#333333"
  readonly property string muted: "#757575"
  readonly property string accent: "#000000"
  readonly property string accent_alt: "#424242"
  readonly property string success: "#222222" // E-ink handles status best with distinct grays/blacks or icons
  readonly property string warning: "#616161"
  readonly property string critical: "#000000"

  readonly property string fontFamily: "JetBrainsMono Nerd Font"
  readonly property int fontSize: 14
}
