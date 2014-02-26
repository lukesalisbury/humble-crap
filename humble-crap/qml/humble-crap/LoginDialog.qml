import QtQuick 2.0
import QtQuick.Controls 1.0

Rectangle {
	id: pageLogin
	x: 0
	y: 0
	width: (parent.width ? parent.width : 200)
	height: (parent.height ? parent.height : 200)
	color: "#c8000000"
	opacity: 1

	z: 1

	MouseArea {
		id: mousearea1
		x: 0
		y: 0
		width: parent.width
		height: parent.height
		propagateComposedEvents: false

		Rectangle {
			id: dialogLogin
			x: 0
			y: 0
			width: 360
			height: 180
			color: "#6d1d1d"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			z: 11
			ActionButton {
				id: buttonLogon
				x: 261
				y: 114
				width: 76
				height: 40
				text: "Login"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 20
				anchors.right: parent.right
				anchors.rightMargin: 20
				z: 1
				opacity: 1
				KeyNavigation.tab: inputUser
				onClicked: {
					this.enabled = false
					textMessage.text = "logging in"
					downloadHumble.login(inputUser.text, inputPassword.text,
										 inputSavePass.checked)
				}
				Keys.onReturnPressed: {
					buttonLogon.clicked()
				}
			}

			Rectangle {
				id: rectangle2
				x: 178
				y: 24
				width: 159
				height: 22
				color: "#ffffff"

				TextInput {
					id: inputUser
					text: downloadHumble.getUsername()
					clip: false
					anchors.fill: parent
					font.pixelSize: 12
					KeyNavigation.tab: inputPassword
					Keys.onReturnPressed: {
						buttonLogon.clicked()
					}
				}
			}

			Rectangle {
				id: rectangle3
				x: 178
				y: 59
				width: 159
				height: 23
				color: "#ffffff"

				TextInput {
					id: inputPassword
					text: downloadHumble.getPassword()
					anchors.fill: parent
					echoMode: TextInput.Password
					font.pixelSize: 12
					KeyNavigation.tab: inputSavePass
					Keys.onReturnPressed: {
						buttonLogon.clicked()
					}
				}
			}

			Text {
				id: text1
				x: 134
				y: 28
				text: qsTr("Email:")
				font.bold: true
				color: "#ffffff"
				horizontalAlignment: Text.AlignRight
				font.pixelSize: 12
			}

			Text {
				id: text2
				x: 114
				y: 64
				color: "#ffffff"
				text: qsTr("Password")
				font.bold: true
				horizontalAlignment: Text.AlignRight
				font.pixelSize: 12
			}

			CheckBox {
				id: inputSavePass
				x: 178
				y: 88
				checked: downloadHumble.getSavePassword()
				text: "Save Password"
				KeyNavigation.tab: buttonLogon
			}

			Image {
				id: image1
				x: 8
				y: 8
				width: 100
				height: 100
				source: "humble-crap64.png"
			}

			Text {
				id: textMessage
				x: 17
				y: 133
				width: 233
				height: 14
				color: "#ffffff"
				text: qsTr("")
				font.bold: true
				font.pixelSize: 12
			}

			Text {
				id: textWarning
				x: 17
				y: 167
				color: "#ffffff"
				text: qsTr("Unofficial - http://github.com/lukesalisbury/humble-crap/")
				font.pointSize: 8
			}
			Connections {
				target: downloadHumble
				onAppError: {
					buttonLogon.enabled = true
					textMessage.text = downloadHumble.getErrorMessage()
				}
				onAppSuccess: {
					pageMainWindow.refresh()
					pageLogin.destroy()
				}
			}
		}
	}
}
