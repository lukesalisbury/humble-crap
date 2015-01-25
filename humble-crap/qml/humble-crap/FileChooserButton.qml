/****************************************************************************
* Copyright (c) 2015 Luke Salisbury
*
* This software is provided 'as-is', without any express or implied
* warranty. In no event will the authors be held liable for any damages
* arising from the use of this software.
*
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
*
* 1. The origin of this software must not be misrepresented; you must not
*    claim that you wrote the original software. If you use this software
*    in a product, an acknowledgement in the product documentation would be
*    appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
*    misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
****************************************************************************/
import QtQuick 2.2
import QtQuick.Dialogs 1.0

Rectangle {
	property alias selectFolder: fileDialog.selectFolder
	property alias selectExisting: fileDialog.selectExisting
	property alias title: textTitle.text
	property alias value: textInput.text
	property url address: ""
	property alias directory: fileDialog.folder
	signal accepted
	signal rejected
	id: rectangleArea
	width: 174
	height: 49
	antialiasing: true
	clip: false
	border.width: 0

	TextInput {
		id: textInput
		text: "<directory>"
		clip: true
		anchors.right: dialogButton.left
		anchors.rightMargin: 6
		horizontalAlignment: Text.AlignLeft
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 6
		anchors.left: parent.left
		anchors.leftMargin: 6
		anchors.top: textTitle.bottom
		anchors.topMargin: 6
	}

	DialogButton {
		id: dialogButton
		x: 119
		y: 0
		width: 47
		height: 37
		text: "Choose"
		anchors.right: parent.right
  anchors.rightMargin: 8
		anchors.top: parent.top
		anchors.topMargin: 6
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 6

		onClicked: {
			directory = Qt.resolvedUrl(value)
			fileDialog.open()
		}
	}

	Text {
		id: textTitle
		y: 6
		text: "parent.value"
		anchors.left: parent.left
		anchors.leftMargin: 6
		font.bold: true
		verticalAlignment: Text.AlignVCenter
		anchors.top: parent.top
		anchors.topMargin: 6
		horizontalAlignment: Text.AlignLeft
	}

	FileDialog {
		visible: false
		id: fileDialog
		title: "Please choose a file"

		onAccepted: {
			console.log("You chose: " + fileDialog.fileUrls)
			value = Qt.resolvedUrl(fileDialog.fileUrls[0]);
			close()
			rectangleArea.accepted()
		}
		onRejected: {
			console.log("Canceled")
			close()
			rectangleArea.rejected()
		}
	}
}
