import QtQuick 2.2
import QtQuick.Dialogs 1.0

Rectangle {
	property alias selectFolder: fileDialog.selectFolder
	property alias selectExisting: fileDialog.selectExisting
	id: rectangle1
	width: 156
	height: 32
	border.width: 0



	TextInput {
		id: textInput1
		text: qsTr("")
		anchors.left: parent.left
		anchors.leftMargin: 6
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 6
		anchors.top: parent.top
		anchors.topMargin: 6
		anchors.right: dialogButton1.left
		anchors.rightMargin: 6
		font.pixelSize: 12
	}

	DialogButton {
		id: dialogButton1
		x: 86
		text: "Choose"
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 6
		anchors.top: parent.top
		anchors.topMargin: 6
		anchors.right: parent.right
		anchors.rightMargin: 6

		onClicked: {
			fileDialog.open();
		}
	}
Text {
	id: text1
	x: 6
	text: "Message"
	verticalAlignment: Text.AlignVCenter
	anchors.bottom: parent.bottom
 anchors.bottomMargin: 6
 anchors.top: parent.top
 anchors.topMargin: 6
	horizontalAlignment: Text.AlignRight
	anchors.right: textInput1.left
	anchors.rightMargin: 6
	font.pixelSize: 12
}

FileDialog {
	visible: false
		id: fileDialog
		title: "Please choose a file"

		onAccepted: {
			console.log("You chose: " + fileDialog.fileUrls)
			close()
		}
		onRejected: {
			console.log("Canceled")
			close()
		}
	}

}
