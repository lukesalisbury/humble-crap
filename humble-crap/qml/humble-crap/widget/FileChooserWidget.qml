import QtQuick 2.11
import QtQuick.Dialogs 1.2


import "../dialog"

Item {
	id: path

	property alias title: textTitle.text
	property alias value: textInput.text
	property bool wantDirectory: true
	width: 500
	height: 56

	FileDialog {
		id: fileDialog

		visible: false
		modality: Qt.WindowModal
		title: wantDirectory ? "Choose a folder" : "Choose a file"
		selectExisting: !wantDirectory
		selectFolder: wantDirectory
		nameFilters: [ "All files (*)" ]
		selectedNameFilter: "All files (*)"
		sidebarVisible: true
		onAccepted: {
			path.value = humbleCrap.makeLocal(fileDialog.fileUrls[0]);
		}
		onRejected: { console.log("Rejected") }

	}

	Text {
		id: textTitle
		color: "#000000"
		text: "Title"
		font.pointSize: 10
		anchors.top: parent.top
		anchors.topMargin: 6
		horizontalAlignment: Text.AlignRight
		anchors.rightMargin: 8
		anchors.leftMargin: 0

		verticalAlignment: Text.AlignVCenter
		anchors.left: parent.left
		font.bold: false
	}

	DialogButton {
		id: dialogSetPath
		y: 54
		text: "Select"
		anchors.verticalCenter: textTitle.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: 0
		onClicked:{
			//Qt.createComponent("FileChooserDialog.qml").createObject(pageMainWindow, { selectFolder: true, folder: path.value } )
			fileDialog.open()
		}

	}

	Rectangle {
		id: rectangle1
		height: 24
		color: "#ffffff"
		anchors.top: textTitle.bottom
		anchors.topMargin: 6
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0

		TextInput {
			id: textInput
			y: 0
			text: '<directory>'
			antialiasing: true
			clip: true
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
   anchors.left: parent.left
			font.pixelSize: 12
		}
	}
}
