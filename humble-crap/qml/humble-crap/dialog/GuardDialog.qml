import QtQuick 2.0
import QtQuick.Window 2.3

import "../widget"

Window {
	id: pageGuard
	color: "#60000000"
	opacity: 1
	width: 320
	height: 124
	visible: true
	title: "2 Factor Authentication"
	modality: Qt.WindowModal
	flags: Qt.SplashScreen
	Rectangle {
		id: rectangle
		color: "#e6e6e6"
		radius: 1
		border.width: 2
		anchors.fill: parent

		Text {
			id: text1
			y: 24
			text: qsTr("Authentication code")
			anchors.right: parent.right
			anchors.rightMargin: 24
			anchors.left: parent.left
			anchors.leftMargin: 24
			font.weight: Font.Bold
			font.bold: true
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignLeft
			font.pixelSize: 12
		}

		Item {
			id: itemFooter
			x: 24
			y: 46
			anchors.top: text1.bottom
			anchors.topMargin: 8
			anchors.left: parent.left
			anchors.rightMargin: 24
			anchors.right: parent.right
			anchors.leftMargin: 24
			TextEntry {
				id: entryGuard
				anchors.left: buttonOpenCaptcha.right
				anchors.leftMargin: 8
				placeholder: 'Enter Code here'
			}

			ActionButton {
				id: buttonClose
				text: "Submit"
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: entryGuard.right
				anchors.leftMargin: 8
				onClicked: {
					if ( entryGuard.text )
						inputPin.text = entryGuard.text
					pageGuard.destroy()
				}
			}
		}
	}
}
