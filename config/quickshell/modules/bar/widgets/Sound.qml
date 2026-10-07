pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.Pipewire

Singleton {
  id: root
  readonly property bool headphonesConnected: false
  readonly property bool isMuted: Pipewire.defaultAudioSink?.audio?.muted ?? true
  readonly property int volume: (Pipewire.defaultAudioSink?.audio?.volume ?? 0) * 100

  PwObjectTracker { objects: [Pipewire.defaultAudioSink] }
}