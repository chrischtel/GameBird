import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import GameBird 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 800
    title: "GameBird - Game Library Manager"
    
    property string currentView: "library" // library, favorites, settings
    
    // Color scheme
    readonly property color backgroundColor: "#1a1a1a"
    readonly property color sidebarColor: "#2d2d2d"
    readonly property color accentColor: "#0078d4"
    readonly property color hoverColor: "#3a3a3a"
    readonly property color textColor: "#ffffff"
    readonly property color secondaryTextColor: "#cccccc"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar
        Rectangle {
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            color: sidebarColor

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                // Logo/Title area
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    color: "transparent"
                    
                    Text {
                        text: "🎮 GameBird"
                        color: textColor
                        font.pixelSize: 18
                        font.weight: Font.Medium
                        anchors.centerIn: parent
                    }
                }

                // Separator
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    Layout.leftMargin: 12
                    Layout.rightMargin: 12
                    color: hoverColor
                }

                // Navigation buttons
                Repeater {
                    model: [
                        { text: "Library", id: "library", icon: "📚" },
                        { text: "Favorites", id: "favorites", icon: "⭐" },
                        { text: "Settings", id: "settings", icon: "⚙️" }
                    ]

                    delegate: Rectangle {
                        Layout.fillWidth: true
                        height: 44
                        color: currentView === modelData.id ? accentColor : "transparent"
                        radius: 6

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 12

                            Text {
                                text: modelData.icon
                                color: currentView === modelData.id ? "#ffffff" : secondaryTextColor
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text: modelData.text
                                color: currentView === modelData.id ? "#ffffff" : textColor
                                font.pixelSize: 14
                                font.weight: currentView === modelData.id ? Font.Medium : Font.Normal
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onEntered: {
                                if (currentView !== modelData.id) {
                                    parent.color = hoverColor
                                }
                            }
                            
                            onExited: {
                                if (currentView !== modelData.id) {
                                    parent.color = "transparent"
                                }
                            }
                            
                            onClicked: {
                                currentView = modelData.id
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true } // Spacer

                // Separator
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    Layout.leftMargin: 12
                    Layout.rightMargin: 12
                    color: hoverColor
                }

                // Game count
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    color: "transparent"
                    
                    Text {
                        text: "Games: " + gameLibrary.count
                        color: secondaryTextColor
                        font.pixelSize: 12
                        anchors.centerIn: parent
                    }
                }
            }
        }

        // Main content area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: backgroundColor

            StackLayout {
                id: contentStack
                anchors.fill: parent
                currentIndex: {
                    switch (currentView) {
                        case "library": return 0
                        case "favorites": return 1
                        case "settings": return 2
                        default: return 0
                    }
                }

                // Library View
                Rectangle {
                    color: backgroundColor

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16

                        // Header with Add Game button
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            color: "transparent"
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 4
                                anchors.rightMargin: 4

                                Text {
                                    text: "Game Library"
                                    color: textColor
                                    font.pixelSize: 22
                                    font.weight: Font.Medium
                                    Layout.fillWidth: true
                                }

                                Button {
                                    text: "➕ Add Game"
                                    onClicked: addGameDialog.open()
                                    
                                    background: Rectangle {
                                        color: parent.hovered ? "#1a7bc7" : accentColor
                                        radius: 6
                                        
                                        Behavior on color {
                                            ColorAnimation { duration: 150 }
                                        }
                                    }
                                    
                                    contentItem: Text {
                                        text: parent.text
                                        color: textColor
                                        font.pixelSize: 13
                                        font.weight: Font.Medium
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }
                        }

                        // Games list
                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            ListView {
                                id: gamesListView
                                model: gameLibrary
                                spacing: 8

                                delegate: GameItem {
                                    width: gamesListView.width
                                    gameTitle: title
                                    gameExecutablePath: executablePath
                                    gameIconPath: iconPath
                                    gameIsFavorite: isFavorite
                                    
                                    onLaunchRequested: gameLibrary.launchGame(index)
                                    onFavoriteToggled: gameLibrary.toggleFavorite(index)
                                    onRemoveRequested: gameLibrary.removeGame(index)
                                }
                            }
                        }

                        // Empty state
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: gameLibrary.count === 0

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 16

                                Text {
                                    text: "🎮"
                                    font.pixelSize: 48
                                    color: secondaryTextColor
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: "No games in your library yet"
                                    color: secondaryTextColor
                                    font.pixelSize: 18
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: "Click \"Add Game\" to get started!"
                                    color: secondaryTextColor
                                    font.pixelSize: 14
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                    }
                }

                // Favorites View
                Rectangle {
                    color: backgroundColor

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16

                        Text {
                            text: "Favorite Games"
                            color: textColor
                            font.pixelSize: 24
                            font.bold: true
                        }

                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            ListView {
                                model: gameLibrary
                                spacing: 8
                                
                                delegate: Loader {
                                    width: parent.width
                                    active: isFavorite
                                    visible: active
                                    
                                    sourceComponent: GameItem {
                                        width: parent.width
                                        gameTitle: title
                                        gameExecutablePath: executablePath
                                        gameIconPath: iconPath
                                        gameIsFavorite: isFavorite
                                        
                                        onLaunchRequested: gameLibrary.launchGame(index)
                                        onFavoriteToggled: gameLibrary.toggleFavorite(index)
                                        onRemoveRequested: gameLibrary.removeGame(index)
                                    }
                                }
                            }
                        }
                    }
                }

                // Settings View
                Rectangle {
                    color: backgroundColor

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16

                        Text {
                            text: "Settings"
                            color: textColor
                            font.pixelSize: 24
                            font.bold: true
                        }

                        // Placeholder settings
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 200
                            color: sidebarColor
                            radius: 8
                            border.color: hoverColor

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 16

                                Text {
                                    text: "General"
                                    color: textColor
                                    font.bold: true
                                    font.pixelSize: 16
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 1
                                    color: hoverColor
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    RowLayout {
                                        Layout.fillWidth: true
                                        
                                        Text {
                                            text: "Theme:"
                                            color: textColor
                                            Layout.preferredWidth: 100
                                        }
                                        
                                        Text {
                                            text: "Dark (Coming Soon)"
                                            color: secondaryTextColor
                                            Layout.fillWidth: true
                                        }
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        
                                        Text {
                                            text: "Library Path:"
                                            color: textColor
                                            Layout.preferredWidth: 100
                                        }
                                        
                                        Text {
                                            text: gameLibrary.getLibraryPath()
                                            color: secondaryTextColor
                                            wrapMode: Text.Wrap
                                            Layout.fillWidth: true
                                            font.pixelSize: 11
                                        }
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        
                                        Text {
                                            text: "Version:"
                                            color: textColor
                                            Layout.preferredWidth: 100
                                        }
                                        
                                        Text {
                                            text: gameLibrary.getAppVersion()
                                            color: secondaryTextColor
                                            Layout.fillWidth: true
                                        }
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        
                                        Text {
                                            text: "Games:"
                                            color: textColor
                                            Layout.preferredWidth: 100
                                        }
                                        
                                        Text {
                                            text: gameLibrary.count + " total"
                                            color: secondaryTextColor
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }
    }

    // Add Game Dialog
    Dialog {
        id: addGameDialog
        title: "Add New Game"
        width: 500
        height: 340
        anchors.centerIn: parent
        modal: true

        property string selectedPath: ""

        // Modern dark theme background with shadow effect
        background: Rectangle {
            color: sidebarColor
            border.color: hoverColor
            border.width: 1
            radius: 12

            // Drop shadow effect
            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                color: "transparent"
                border.color: Qt.rgba(0, 0, 0, 0.3)
                border.width: 1
                radius: parent.radius + 1
                z: -1
            }
        }

        // Clean header with separator
        header: Rectangle {
            height: 60
            color: "transparent"
            
            Text {
                text: "Add New Game"
                color: textColor
                font.pixelSize: 18
                font.weight: Font.Medium
                anchors.centerIn: parent
            }
            
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                height: 1
                color: hoverColor
            }
        }

        contentItem: Rectangle {
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 20

                // Executable selection section
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: "Game Executable"
                        color: textColor
                        font.pixelSize: 15
                        font.weight: Font.Medium
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            color: backgroundColor
                            border.color: pathField.activeFocus ? accentColor : hoverColor
                            border.width: 1
                            radius: 8

                            TextInput {
                                id: pathField
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                text: addGameDialog.selectedPath
                                color: text ? textColor : secondaryTextColor
                                readOnly: true
                                verticalAlignment: TextInput.AlignVCenter
                                font.pixelSize: 13
                                selectByMouse: true
                                clip: true
                                
                                Text {
                                    text: "Select game executable..."
                                    color: secondaryTextColor
                                    visible: !pathField.text
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.pixelSize: 13
                                }
                            }
                        }

                        Button {
                            text: "Browse..."
                            Layout.preferredWidth: 90
                            height: 40
                            
                            onClicked: {
                                var path = gameLibrary.openFileDialog()
                                if (path) {
                                    addGameDialog.selectedPath = path
                                    titleField.text = path.split('/').pop().split('\\').pop().replace('.exe', '')
                                    titleField.focus = true
                                }
                            }
                            
                            background: Rectangle {
                                color: parent.hovered ? "#1985d1" : accentColor
                                radius: 8
                                
                                Behavior on color {
                                    ColorAnimation { duration: 200 }
                                }
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: textColor
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }

                // Game title section
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: "Game Title"
                        color: textColor
                        font.pixelSize: 15
                        font.weight: Font.Medium
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 40
                        color: backgroundColor
                        border.color: titleField.activeFocus ? accentColor : hoverColor
                        border.width: 1
                        radius: 8

                        TextInput {
                            id: titleField
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            color: textColor
                            font.pixelSize: 13
                            verticalAlignment: TextInput.AlignVCenter
                            selectByMouse: true
                            
                            Text {
                                text: "Enter a custom title for your game..."
                                color: secondaryTextColor
                                visible: !titleField.text
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 13
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true } // Spacer
            }
        }

        // Modern footer with clean buttons
        footer: Rectangle {
            height: 70
            color: "transparent"
            
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                height: 1
                color: hoverColor
            }
            
            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                Button {
                    text: "Cancel"
                    Layout.preferredWidth: 80
                    height: 36
                    
                    background: Rectangle {
                        color: parent.hovered ? hoverColor : "transparent"
                        border.color: hoverColor
                        border.width: 1
                        radius: 8
                        
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: secondaryTextColor
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        addGameDialog.selectedPath = ""
                        titleField.text = ""
                        addGameDialog.reject()
                    }
                }

                Button {
                    text: "Add Game"
                    enabled: addGameDialog.selectedPath && titleField.text
                    Layout.preferredWidth: 100
                    height: 36
                    
                    background: Rectangle {
                        color: parent.enabled ? 
                              (parent.hovered ? "#1985d1" : accentColor) : 
                              hoverColor
                        radius: 8
                        
                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: parent.enabled ? textColor : secondaryTextColor
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        if (addGameDialog.selectedPath && titleField.text) {
                            gameLibrary.addGame(titleField.text, addGameDialog.selectedPath)
                            addGameDialog.selectedPath = ""
                            titleField.text = ""
                            addGameDialog.accept()
                        }
                    }
                }
            }
        }
    }

    // Error handling
    Connections {
        target: gameLibrary
        function onErrorOccurred(message) {
            errorDialog.text = message
            errorDialog.open()
        }
    }

    Dialog {
        id: errorDialog
        title: "Error"
        property alias text: errorText.text
        width: 350
        height: 150
        anchors.centerIn: parent
        modal: true
        
        // Dark theme background
        background: Rectangle {
            color: sidebarColor
            border.color: hoverColor
            border.width: 1
            radius: 8
        }

        // Title styling
        header: Rectangle {
            height: 40
            color: backgroundColor
            radius: 8
            
            Text {
                text: errorDialog.title
                color: textColor
                font.bold: true
                font.pixelSize: 16
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        contentItem: Rectangle {
            color: sidebarColor
            radius: 4

            Text {
                id: errorText
                color: textColor
                wrapMode: Text.Wrap
                anchors.fill: parent
                anchors.margins: 20
                verticalAlignment: Text.AlignVCenter
            }
        }

        footer: Rectangle {
            height: 50
            color: backgroundColor
            radius: 8

            Button {
                text: "OK"
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                onClicked: errorDialog.close()
                
                background: Rectangle {
                    color: accentColor
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    color: textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                }
            }
        }
    }
}
