import QtQuick 2.0

import "../widget"


Rectangle {
	id: rectangle2
	Rectangle {
		id: rectangle1
		height: 109
		color: "#e34949"
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.top: parent.top
		anchors.topMargin: 0

		Text {
			id: text1
			color: "#ffffff"
			text: qsTr("Error")
			anchors.left: parent.left
			anchors.leftMargin: 16
			anchors.top: parent.top
			anchors.topMargin: 16
			font.pixelSize: 25
		}


	}
	DialogButton {
		id: buttonClose
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 16
		text: "Close"
		anchors.right: parent.right
		anchors.rightMargin: 32
		colour: "#8a000000"

		onClicked: {
			parent.destroy()
		}
	}
}
