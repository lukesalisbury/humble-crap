/****************************************************************************
* Copyright © 2015 Luke Salisbury
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
import QtQuick 2.0
import QtGraphicalEffects 1.0

import "../widget"

Rectangle {
	//Cause the parent might use archor fill, we use custom properties for dimension
	property int requestedWidth: 320
	property int requestedHeight: 400

	id: dialogLogin
	opacity: 1
	z: 1
	x: 0
	y: 0
	width: requestedWidth
	height: requestedHeight
	color: "#ffffff"
	anchors.fill: parent

	Text {
		id: textTitle
		x: 0
		y: 0
		width: 0
		height: 24
		text: qsTr("Humble Login")
		anchors.right: parent.right
		anchors.rightMargin: 24
		anchors.left: parent.left
		anchors.leftMargin: 24
		anchors.top: parent.top
		anchors.topMargin: 24
		font.pointSize: 14
	}

	Item {
		id: itemUser
		width: 300
		height: 24
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: textTitle.bottom
		anchors.topMargin: 24
		Text {
			id: textUser
			color: "#000000"
			text: qsTr("Email:")
			anchors.verticalCenter: inputUser.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: 24
			anchors.right: inputUser.left
			anchors.rightMargin: 8
			font.bold: true
			horizontalAlignment: Text.AlignRight
		}

		TextEntry {
			id: inputUser
			x: 0
			y: 0
			width: 200
			height: 23
			anchors.right: parent.right
			anchors.rightMargin: 24
			KeyNavigation.tab: inputPassword
			Keys.onReturnPressed: {
				buttonLogon.clicked()
			}
			text: humbleUser.getUser()
		}
	}

	Item {
		id: itemPassword
		width: 300
		height: 24
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: itemUser.bottom
		anchors.topMargin: 8
		Text {
			id: textPassword
			color: "#000000"
			text: qsTr("Password:")
			anchors.verticalCenter: inputPassword.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: 24
			anchors.right: inputPassword.left
			anchors.rightMargin: 8
			font.bold: true
			horizontalAlignment: Text.AlignRight
		}
		TextEntry {
			id: inputPassword
			x: 0
			y: 0
			width: 200
			height: 23
			anchors.right: parent.right
			anchors.rightMargin: 24
			echoMode: TextInput.Password
			KeyNavigation.tab: inputPin
			text: humbleCrap.getValue('password')
			Keys.onReturnPressed: {
				buttonLogon.clicked()
			}
		}
	}

	Item {
		id: itemPin
		width: 300
		height: 24
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: itemPassword.bottom
		anchors.topMargin: 8
		Text {
			id: textPin
			text: qsTr("Pin:")
			horizontalAlignment: Text.AlignRight
			anchors.verticalCenter: inputPin.verticalCenter
			anchors.right: inputPin.left
			anchors.rightMargin: 8
			anchors.left: parent.left
			anchors.leftMargin: 24
			font.bold: true
		}
		TextEntry {
			id: inputPin
			x: 0
			y: 0
			width: 136
			height: 23
			anchors.right: parent.right
			anchors.rightMargin: 88
			KeyNavigation.tab: buttonLogon
			Keys.onReturnPressed: {
				buttonLogon.clicked()
			}
		}

	}
	Item {
		id: itemCaptcha
		width: 300
		height: 24
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: itemPin.bottom
		anchors.topMargin: 8
		Text {
			id: textCaptcha
			text: qsTr("Captcha:")
			anchors.verticalCenter: inputCaptcha.verticalCenter
			anchors.left: parent.left
			anchors.leftMargin: 24
			anchors.right: inputCaptcha.left
			anchors.rightMargin: 8
			horizontalAlignment: Text.AlignRight
			font.bold: true
		}

		TextEntry {
			id: inputCaptcha
			width: 200 - buttonCaptcha.width - 8
			height: 23
			text: humbleUser.getCaptcha()
			anchors.rightMargin: 8
			anchors.right: buttonCaptcha.left
		}
		ActionButton {
			id: buttonCaptcha
			text: 'Get'
			anchors.rightMargin: 24
			anchors.right: parent.right
			onClicked: {
				Qt.createComponent("CaptchaNoteDialog.qml").createObject( parent)
			}
		}
	}

	Text {
		id: textMessage
		height: 24
		color: "#000000"
		text: qsTr("")
		elide: Text.ElideMiddle
		anchors.top: itemCaptcha.top
		anchors.topMargin: 24
		horizontalAlignment: Text.AlignHCenter
		wrapMode: Text.WordWrap

		anchors.right: parent.right
		anchors.rightMargin: 24
		anchors.left: parent.left
		anchors.leftMargin: 24

		font.bold: true
	}

	Item {
		id: itemFooter
		anchors.top: textMessage.top
		anchors.topMargin: 0
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0
		Text {
			id: textWarning
			color: "#000000"
			text: "Website - https://github.com/lukesalisbury/humble-crap/"
			font.family: "Verdana"
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignBottom
			anchors.bottom: rectangle1.top
			anchors.right: parent.right
			anchors.rightMargin: 24
			anchors.left: parent.left
			anchors.leftMargin: 24
			font.pointSize: 7
		}

		Rectangle {
			id: rectangle1
			x: 0
			y: 267
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

		DialogButton {
			id: buttonLogon
			x: 228
			y: 280
			text: "Login"
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 16
			anchors.right: parent.right
			anchors.rightMargin: 24
			z: 1
			opacity: 1
			KeyNavigation.tab: inputUser
			onClicked: {
				this.disable = true
				textMessage.text = "logging in"

				humbleCrap.setUsername(inputUser.text) // Set Active Users
				humbleUser.setCaptcha('',inputCaptcha.text)
				humbleUser.login(inputUser.text, inputPassword.text,
								 inputPin.text)
			}

			Keys.onReturnPressed: {
				buttonLogon.clicked()
			}
		}

		DialogButton {
			id: buttonClose
			x: 24
			y: 280
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
				buttonClose.clicked()
			}
		}
	}
	/* Creation */
	Component.onCompleted: {
		humbleUser.gatherLoginToken()
	}

	/* C++ Connections */
	Connections {
		target: humbleUser
		onLoginError: {
			console.log('LoginDialog', 'onLoginError')
			buttonLogon.disable = false
			textMessage.text = humbleUser.getErrorMessage()
		}
		onCaptchaRequired: {
			console.log('LoginDialog', 'onCaptchaRequired')
			buttonLogon.disable = false
			textMessage.text = humbleUser.getErrorMessage()
		}
		onGuardRequired: {
			console.log('LoginDialog', 'onGuardRequired')
			buttonLogon.disable = false
			textMessage.text = humbleUser.getErrorMessage()
			Qt.createComponent("GuardDialog.qml").createObject( parent)
		}
		onLoginRequired: {
			console.log('LoginDialog', 'onLoginRequired')
			buttonLogon.disable = false
			textMessage.text = ''
		}
	}
}
