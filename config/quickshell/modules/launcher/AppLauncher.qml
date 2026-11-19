import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import qs

PanelWindow {
    id : root

    IpcHandler {
        target: "applauncher"
        function toggle() { AppLauncherState.toggle() }
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: AppLauncherState.launcherVisible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.namespace: "quickshell-launcher"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    mask: Region {
        item: AppLauncherState.launcherVisible ? maskCover : null
    }

    Item {
        id: maskCover
        anchors.fill: parent
    }

    color: "transparent"

    property string searchQuery: ""
    property int selectedIndex: 0
    readonly property bool isSearching: searchQuery.trim() !== ""

    property var filteredApps: {
        const q = searchQuery.trim().toLowerCase()
        const vals = [...DesktopEntries.applications.values].filter(e => !e.noDisplay)

        if (q === "") {
            const recent = AppLauncherState.recentIds
            return vals.sort((a, b) => {
                const ai = recent.indexOf(a.id)
                const bi = recent.indexOf(b.id)
                if (ai !== -1 && bi !== -1) return ai - bi
                if (ai !== -1) return -1
                if (bi !== -1) return 1
                return a.name.localeCompare(b.name)
            })
        }

        return vals.filter(e => {
            if ((e.name ?? "").toLowerCase().includes(q)) return true
            if ((e.genericName ?? "").toLowerCase().includes(q)) return true
            return (e.keywords ?? []).some(k => k.toLowerCase().includes(q))
        }).sort((a, b) => {
            const as = a.name.toLowerCase().startsWith(q)
            const bs = b.name.toLowerCase().startsWith(q)
            if (as !== bs) return as ? -1 : 1
            return a.name.localeCompare(b.name)
        })
    }

    onFilteredAppsChanged: selectedIndex = 0

    function launchEntry(entry) {
        AppLauncherState.recordLaunch(entry.id)
        entry.execute()
        AppLauncherState.hide()
    }

    function navigate(delta) {
        if (filteredApps.length === 0) return
        selectedIndex = (selectedIndex + delta + filteredApps.length) % filteredApps.length
        listView.positionViewAtIndex(selectedIndex, ListView.Contain)
    }

    Connections {
        target: AppLauncherState
        function onLauncherVisibleChanged() {
            if (AppLauncherState.launcherVisible) {
                searchInput.text = ""
                root.searchQuery = ""
                root.selectedIndex = 0
                searchInput.forceActiveFocus()
            }
        }
    }

    readonly property int maxVisible: 7
    readonly property int itemHeight: 52
    readonly property int panelWidth: 440
    readonly property int panelHeight: contentColumn.implicitHeight + 24

    property real lastMouseX: -1
    property real lastMouseY: -1

    property real wheelAccum: 0

    function mouseReallyMoved(area, mouse) {
        const p = area.mapToItem(null, mouse.x, mouse.y)
        if (p.x === lastMouseX && p.y === lastMouseY) return false
        lastMouseX = p.x
        lastMouseY = p.y
        return true
    }

    MouseArea {
        anchors.fill: parent
        enabled: AppLauncherState.launcherVisible
        onClicked: AppLauncherState.hide()
    }

    Rectangle {
        id: panel
        width: root.panelWidth
        height: root.panelHeight
        Behavior on height {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }

        clip: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        color: Colors.bg
        topLeftRadius: 18
        topRightRadius: 18
        bottomLeftRadius: 0
        bottomRightRadius: 0
        border.color: Colors.accent
        border.width: 1

        transform: Translate {
            y: AppLauncherState.launcherVisible ? 0 : root.panelHeight + 6
            Behavior on y {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutCubic
                }
            }
        }

        Column {
            id: contentColumn
            anchors {
                top: parent.top
                topMargin: 12
                left: parent.left
                leftMargin: 12
                right: parent.right
                rightMargin: 12
            }
            spacing: 0

            Rectangle {
                width: 36
                height: 4
                radius: 2
                anchors.horizontalCenter: parent.horizontalCenter
                color: Colors.surface
            }

            Item {
                width: 1
                height: 8
            }

            Rectangle {
                width: parent.width
                height: 44
                radius: 10
                color: Colors.surface

                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    color: "transparent"
                    border.color: Colors.accent
                    border.width: 1
                    opacity: searchInput.activeFocus ? 0.55 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 150
                        }
                    }
                }

                Item {
                    anchors {
                        fill: parent
                        leftMargin: 16
                        rightMargin: 16
                    }

                    Text {
                        anchors.fill: parent
                        text: root.isSearching ? "" : "Search apps..."
                        color: Colors.fg
                        opacity: 0.28
                        font{
                            pixelSize: Colors.fontSize
                            family: Colors.fontFamily
                        }
                        verticalAlignment: Text.AlignVCenter
                        visible: searchInput.text === ""
                    }

                    TextInput {
                        id: searchInput
                        anchors.fill: parent
                        color: Colors.fg
                        selectionColor: Colors.accent
                        font{
                            pixelSize: Colors.fontSize
                            family: Colors.fontFamily
                        }
                        verticalAlignment: Text.AlignVCenter
                        clip: true

                        onTextChanged: root.searchQuery = text

                        Keys.onPressed: function (event) {
                            if (event.key === Qt.Key_Up) {
                                root.navigate(-1)
                                event.accepted = true
                            } else if (event.key === Qt.Key_Down) {
                                root.navigate(1)
                                event.accepted = true
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                if (root.filteredApps.length > 0) {
                                    root.launchEntry(root.filteredApps[root.selectedIndex])
                                    event.accepted = true
                                }
                            } else if (event.key === Qt.Key_Escape) {
                                AppLauncherState.hide()
                                event.accepted = true
                            }
                        }
                    }
                }
            }

            Item {
                width: 1
                height: 8
            }

            ListView {
                id: listView
                width: parent.width
                height: Math.max(1, Math.min(root.filteredApps.length, root.maxVisible)) * root.itemHeight
                model: root.filteredApps
                clip: true
                interactive: false

                Text {
                    anchors.centerIn: parent
                    visible: root.filteredApps.length === 0
                    text: "No results"
                    color: Colors.fg
                    font{
                        pixelSize: Colors.fontSize
                        family: Colors.fontFamily
                    }
                }

                delegate: Item {
                    id: appRow
                    width: listView.width
                    height: root.itemHeight

                    readonly property bool sel: root.selectedIndex === index
                    readonly property bool isRecent: !root.isSearching && AppLauncherState.recentIds.indexOf(modelData.id) !== -1 && AppLauncherState.recentIds.indexOf(modelData.id) < 5

                    Rectangle {
                        anchors {
                            fill: parent
                            topMargin: 2
                            bottomMargin: 2
                        }
                        radius: 10
                        color: appRow.sel ? Colors.surface_bright : "transparent"
                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }

                        Row {
                            anchors {
                                fill: parent
                                leftMargin: 8
                                rightMargin: 8
                            }
                            spacing: 12

                            Rectangle {
                                width: 36
                                height: 36
                                radius: 9
                                anchors.verticalCenter: parent.verticalCenter
                                color: appRow.sel ? Colors.surface_bright : Colors.surface
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 100
                                    }
                                }

                                Image {
                                    id: appIcon
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    source: modelData.icon !== "" ? "image://icon/" + modelData.icon : ""
                                    smooth: true
                                    mipmap: true
                                }

                                Text {
                                    anchors.centerIn: parent
                                    visible: appIcon.status !== Image.Ready
                                    text: modelData.name.charAt(0).toUpperCase()
                                    font {
                                        pixelSize: Colors.fontSize
                                        family: Colors.fontFamily
                                        weight: Font.Bold
                                    }
                                    color: appRow.sel ? Colors.accent_alt : Colors.fg
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 100
                                        }
                                    }
                                }
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2

                                Text {
                                    text: modelData.name
                                    font {
                                        pixelSize: Colors.fontSize
                                        family: Colors.fontFamily
                                        weight: appRow.sel ? Font.Medium : Font.Normal
                                    }
                                    color: appRow.sel ? Colors.fg : Colors.muted
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 100
                                        }
                                    }
                                }

                                Row {
                                    spacing: 6
                                    visible: appRow.isRecent || modelData.genericName !== ""

                                    Rectangle {
                                        visible: appRow.isRecent
                                        width: recentLabel.width + 8
                                        height: 14
                                        radius: 4
                                        color: Colors.accent
                                        anchors.verticalCenter: parent.verticalCenter

                                        Text {
                                            id: recentLabel
                                            anchors.centerIn: parent
                                            text: "Recent"
                                            font {
                                                pixelSize: Colors.fontSize - 2
                                                family: Colors.fontFamily
                                                weight: Font.Medium
                                            }
                                            color: Colors.bg_dark
                                        }
                                    }
                                    Text {
                                        visible: modelData.genericName !== ""
                                        text: modelData.genericName
                                        font {
                                            pixelSize: Colors.fontSize - 2
                                            family: Colors.fontFamily
                                            weight: Font.Normal
                                        }
                                        color: Colors.fg
                                        opacity: 0.35
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                        }
                        MouseArea {
                            id: rowMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onPositionChanged: mouse => {
                                if (root.mouseReallyMoved(rowMouse, mouse))
                                    root.selectedIndex = index
                            }
                            onClicked: root.launchEntry(modelData)
                        }
                    }
                }
            }
            Item {
                width: 1
                height: 4
            }
        }
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: wheel => {
                const d = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.pixelDelta.y * 6
                root.wheelAccum += d
                const step = 80
                while (Math.abs(root.wheelAccum) >= step) {
                    root.navigate(root.wheelAccum < 0 ? 1 : -1)
                    root.wheelAccum -= Math.sign(root.wheelAccum) * step
                }
            }
        }
    }
}
