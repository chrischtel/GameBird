import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: gameItem
    height: 80
    color: gameInfoMouseArea.containsMouse ? "#3a3a3a" : "#2d2d2d"
    radius: 8
    border.color: "#404040"
    border.width: 1

    property string gameTitle: ""
    property string gameExecutablePath: ""
    property string gameIconPath: ""
    property bool gameIsFavorite: false

    signal launchRequested()
    signal favoriteToggled()
    signal removeRequested()

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 16

        // Game Icon
        Rectangle {
            Layout.preferredWidth: 56
            Layout.preferredHeight: 56
            color: "#404040"
            radius: 4

            Text {
                anchors.centerIn: parent
                text: "🎮"
                font.pixelSize: 24
                color: "#cccccc"
            }

            // TODO: Add actual icon support
            // Image {
            //     anchors.fill: parent
            //     source: gameIconPath
            //     fillMode: Image.PreserveAspectFit
            //     visible: gameIconPath !== ""
            // }
        }

        // Game Info
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Text {
                text: gameTitle
                color: "#ffffff"
                font.pixelSize: 16
                font.bold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: gameExecutablePath
                color: "#cccccc"
                font.pixelSize: 12
                Layout.fillWidth: true
                elide: Text.ElideMiddle
            }
            
            // MouseArea only for the game info area
            MouseArea {
                id: gameInfoMouseArea
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton
                
                onDoubleClicked: launchRequested()
            }
        }

        // Action Buttons
        RowLayout {
            spacing: 8

            // Favorite Button
            Button {
                width: 32
                height: 32
                text: gameIsFavorite ? "⭐" : "☆"
                
                background: Rectangle {
                    color: parent.hovered ? "#4a4a4a" : "transparent"
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: favoriteToggled()
            }

            // Launch Button
            Button {
                text: "Launch"
                
                background: Rectangle {
                    color: "#0078d4"
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: launchRequested()
            }

            // Remove Button
            Button {
                width: 32
                height: 32
                text: "🗑️"
                
                background: Rectangle {
                    color: parent.hovered ? "#d13438" : "transparent"
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: removeRequested()
            }
        }
    }
}