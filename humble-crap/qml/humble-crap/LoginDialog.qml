import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.0

Rectangle {
	id: pageLogin
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
			id: dialogLogin
			x: 0
			y: 0
			width: 316
			height: 272
			color: "#ffffff"
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			z: 11
			DialogButton {
				id: buttonLogon
				x: 217
				y: 68
				text: "Login"
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
					buttonLogon.clicked()
				}
			}

			Rectangle {
				id: rectangleEmail
				x: 76
				width: 200
				height: 22
				color: "#00000000"
				anchors.top: textTitle.bottom
				anchors.topMargin: 16
				anchors.right: parent.right
				anchors.rightMargin: 24
				border.color: "#000000"

				TextInput {
					id: inputUser
					color: "#8a000000"
					text: humbleCrap.getUsername()
					selectionColor: "#607d8a"
					anchors.rightMargin: 2
					anchors.leftMargin: 2
					anchors.bottomMargin: 2
					anchors.topMargin: 2
					transformOrigin: Item.Left
					horizontalAlignment: Text.AlignLeft
					clip: false
					anchors.fill: parent
					KeyNavigation.tab: inputPassword
					Keys.onReturnPressed: {
						buttonLogon.clicked()
					}
				}
			}

			Rectangle {
				id: rectanglePassword
				x: 0
				y: 0
				width: 200
				height: 23
				color: "#00000000"
				anchors.top: rectangleEmail.bottom
				anchors.topMargin: 16
				anchors.right: parent.right
				anchors.rightMargin: 24
				border.color: "#000000"

				TextInput {
					id: inputPassword
					color: "#000000"
					text: humbleCrap.getPassword()
					selectionColor: "#607e8a"
					anchors.rightMargin: 2
					anchors.leftMargin: 2
					anchors.bottomMargin: 2
					anchors.topMargin: 2
					anchors.fill: parent
					echoMode: TextInput.Password
					KeyNavigation.tab: inputSavePass
					Keys.onReturnPressed: {
						buttonLogon.clicked()
					}
				}
			}

			Text {
				id: textEmail
				y: 0
				height: 0
				color: "#000000"
				text: qsTr("Email:")
				anchors.verticalCenter: rectangleEmail.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 24
				anchors.right: rectangleEmail.left
				anchors.rightMargin: 8
				verticalAlignment: Text.AlignVCenter
				font.bold: true
				horizontalAlignment: Text.AlignRight
			}

			Text {
				id: textPassword
				x: 0
				y: 0
				height: 0
				color: "#000000"
				text: qsTr("Password:")
				verticalAlignment: Text.AlignVCenter
				anchors.verticalCenter: rectanglePassword.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 24
				anchors.right: rectanglePassword.left
				anchors.rightMargin: 8
				font.bold: true
				horizontalAlignment: Text.AlignRight
			}

			CheckBox {
				id: inputSavePass
				x: 92
				text: "Save Password"
				anchors.top: rectanglePassword.bottom
				anchors.topMargin: 16
				checked: humbleCrap.getSavePassword()
				KeyNavigation.tab: buttonLogon
			}

			Text {
				id: textMessage
				y: 184
				height: 14
				color: "#000000"
				text: qsTr("")
				anchors.right: parent.right
				anchors.rightMargin: 24
				anchors.left: parent.left
				anchors.leftMargin: 24
				font.bold: true
			}

			Text {
				id: textWarning
				y: 204
				color: "#000000"
				text: "Website - http://github.com/lukesalisbury/humble-crap/"
				wrapMode: Text.WrapAnywhere
				anchors.right: parent.right
				anchors.rightMargin: 24
				anchors.left: parent.left
				anchors.leftMargin: 24
				font.pointSize: 8
			}
			Connections {
				target: humbleUser
				onAppError: {
					buttonLogon.enabled = true
					textMessage.text = humbleUser.getErrorMessage()
				}
				onAppSuccess: {
					console.log("logged in")
					pageMainWindow.updateOrders()
					pageLogin.destroy()
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
				anchors.left: parent.left
				anchors.leftMargin: 24
				anchors.top: parent.top
				anchors.topMargin: 24
				font.pointSize: 14
			}

			DialogButton {
				id: buttonClose
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 16
				anchors.left: parent.left
				anchors.leftMargin: 24
				text: "Close"
				colour: "#8a000000"

				KeyNavigation.tab: buttonLogon
				onClicked: {
					Qt.quit()
				}

				Keys.onReturnPressed: {
					buttonLogon.clicked()
				}

			}
		}
	}
}
