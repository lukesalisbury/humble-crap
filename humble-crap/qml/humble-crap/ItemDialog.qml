import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.0

Rectangle {
	id: pageItem
	color: "#60000000"
	opacity: 1
	z: 1
	x: 0
	y: 0
	width: 300
	height: 200
	anchors.fill: parent
	MouseArea {
		id: mousearea1
		anchors.fill: parent
		propagateComposedEvents: false

		Rectangle {
			id: dialogItem
			x: 0
			y: 0
			width: 316
			height: 272
			color: "#ffffff"
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			z: 11
			DialogButton {
				id: buttonPlay
				x: 217
				y: 68
				text: "Download"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 16
				anchors.right: parent.right
				anchors.rightMargin: 24
				z: 1
				opacity: 1
				KeyNavigation.tab: inputUser
				onClicked: {
					this.enabled = false
					textMessage.text = "logging in"

					humbleCrap.setUsername(inputUser.text)
					humbleCrap.setPassword(inputPassword.text, inputSavePass.checked)
					humbleUser.login(inputUser.text, inputPassword.text)
				}

				Keys.onReturnPressed: {
					buttonPlay.clicked()
				}
			}


			Rectangle {
				id: rectangle1
				y: 0
				height: 1
				color: "#1e000000"
				border.color: "#1e000000"
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				border.width: 0
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 48
			}

			Text {
				id: textTitle
				x: 0
				y: 0
				text: qsTr("Login")
				anchors.right: parent.right
	anchors.rightMargin: 24
	anchors.left: parent.left
				anchors.leftMargin: 24
				anchors.top: parent.top
				anchors.topMargin: 24
				font.pointSize: 14
			}

   FileChooserButton {
	   id: fileChooserButton1
	   y: 97
	   height: 33
	   anchors.right: parent.right
	anchors.rightMargin: 24
	anchors.left: parent.left
	   anchors.leftMargin: 24
   }

		}
	}
}
