import QtQuick 2.11

import QtQuick.Window 2.3

import "../widget"

Window {
	id: pageCaptcha
	color: "#60000000"
	opacity: 1
	width: 400
	height: 240
	visible: true
	title: "How to get Captcha Value"
	modality: Qt.WindowModal
	flags: Qt.SplashScreen
	Rectangle {
		id: rectangle
		color: "#e6e6e6"
		radius: 1
		border.width: 2
		anchors.fill: parent

		Column {
			anchors.fill: parent
			id: column
			anchors.rightMargin: 24
			anchors.leftMargin: 24
			anchors.bottomMargin: 24
			anchors.topMargin: 24
			spacing: 8

			Text {
				id: text1
				text: qsTr("Getting the Captcha")
				font.weight: Font.Bold
				font.bold: true
				verticalAlignment: Text.AlignVCenter
				horizontalAlignment: Text.AlignLeft
				font.pixelSize: 12
			}

			Text {
				id: text2
				text: qsTr("Step 1: Open https://www.humblebundle.com/user/captcha in your browser")
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				wrapMode: Text.WordWrap
				verticalAlignment: Text.AlignTop
				font.pixelSize: 12
				horizontalAlignment: Text.AlignLeft
			}
			Text {
				id: text3
				text: qsTr("Step 2: Complete this captcha.")
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				verticalAlignment: Text.AlignTop
				font.pixelSize: 12
				horizontalAlignment: Text.AlignLeft
			}

			Text {
				id: text4
				text: qsTr("Step 3: In the address bar, run the following in the address bar.")
				wrapMode: Text.WordWrap
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				verticalAlignment: Text.AlignTop
				font.pixelSize: 12
				horizontalAlignment: Text.AlignLeft
			}
/*
navigator.clipboard.writeText(captcha.get_response()).then(function() {
;
}, function(err) {
  console.error('Async: Could not copy text: ', err);
});
*/
			TextEdit {
				id: textEdit
				height: 20
				text: "javascript:alert(captcha.get_response());"
				readOnly: true
				horizontalAlignment: Text.AlignRight
				font.pixelSize: 12
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				mouseSelectionMode: TextEdit.SelectWords
				Component.onCompleted: {

					selectAll()

				}
			}

			Text {
				id: text5

				text: qsTr("Step 4: Copy the text from the alert box, and pasted it in the field.")
				wrapMode: Text.WordWrap
				anchors.left: parent.left
				anchors.rightMargin: 0
				anchors.right: parent.right
				anchors.leftMargin: 0
				font.pixelSize: 12
				verticalAlignment: Text.AlignTop
				horizontalAlignment: Text.AlignLeft
			}
			Item {
				id: itemFooter
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 24
				anchors.left: parent.left
				anchors.rightMargin: 0
				anchors.right: parent.right
				anchors.leftMargin: 0
				ActionButton {
					id: buttonOpenCaptcha
					text: "Open Site"
					anchors.left: parent.left
					anchors.leftMargin: 0
					url: 'https://www.humblebundle.com/user/captcha'
					onClicked: {
						humbleCrap.openUrl(this.url)
					}
				}
				TextEntry {
					id: entryCaptcha
					anchors.left: buttonOpenCaptcha.right
					anchors.leftMargin: 8
					placeholder: 'Enter Code here'
				}

				ActionButton {
					id: buttonClose
					text: "Close"
					anchors.right: parent.right
					anchors.rightMargin: 0
					anchors.left: entryCaptcha.right
					anchors.leftMargin: 8
					onClicked: {
						if ( entryCaptcha.text )
							inputCaptcha.text = entryCaptcha.text
						pageCaptcha.destroy()
					}
				}
			}

		}
	}
}
