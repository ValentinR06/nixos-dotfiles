pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool launcherVisible: false
    readonly property var recentIds: adapter.recentIds

    FileView {
        path: Quickshell.statePath("app-launcher.json")
        watchChanges: false
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound) writeAdapter()
        }

        JsonAdapter {
            id: adapter
            property list<string> recentIds: []
        }

        onAdapterUpdated: writeAdapter()
    }

    function toggle() { launcherVisible = !launcherVisible }
    function show() { launcherVisible = true }
    function hide() { launcherVisible = false }

    function recordLaunch(id) {
        var list = Array.from(adapter.recentIds)
        var idx = list.indexOf(id)
        if (idx !== -1) list.splice(idx, 1)
        list.unshift(id)
        adapter.recentIds = list.slice(0, 12)
    }

    function clearRecent() {
        adapter.recentIds = []
    }
}