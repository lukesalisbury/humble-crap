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
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.0

import "../widget"
import "../scripts/GameDatabase.js" as GameDatabase

Rectangle {
	id: pageLogin
	color: "#60000000"
	opacity: 1
	z: 1
	x: 0
	y: 0
	width: 320
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
			z: 11
			width: 316
			height: 316
			color: "#ffffff"
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter

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
					humbleUser.login(inputUser.text, inputPassword.text,
									 inputPin.text)
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
					text: ""
					selectionColor: "#607e8a"
					anchors.rightMargin: 2
					anchors.leftMargin: 2
					anchors.bottomMargin: 2
					anchors.topMargin: 2
					anchors.fill: parent
					echoMode: TextInput.Password
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

			Text {
				id: textMessage
				height: 64
				color: "#000000"
				text: qsTr("")
				wrapMode: Text.WrapAnywhere

				anchors.top: rectanglePin.bottom
				anchors.topMargin: 16
				anchors.right: parent.right
				anchors.rightMargin: 24
				anchors.left: parent.left
				anchors.leftMargin: 24

				font.bold: true
			}

			Text {
				id: textWarning
				y: 204
				height: 24
				color: "#000000"
				text: "Website - http://github.com/lukesalisbury/humble-crap/"
				verticalAlignment: Text.AlignBottom
				anchors.bottom: rectangle1.top
				anchors.bottomMargin: 8
				wrapMode: Text.WrapAnywhere
				anchors.top: textMessage.bottom
				anchors.right: parent.right
				anchors.rightMargin: 24
				anchors.left: parent.left
				anchors.leftMargin: 24
				font.pointSize: 7
			}

			Rectangle {
				id: rectangle1
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

			Rectangle {
				id: rectanglePin
				x: 92
				width: 200
				height: 22
				color: "#00000000"
				anchors.topMargin: 16
				TextInput {
					id: inputPin
					color: "#8a000000"
					text: ""
					anchors.topMargin: 2
					anchors.fill: parent
					transformOrigin: Item.Left
					horizontalAlignment: Text.AlignLeft
					anchors.rightMargin: 2
					selectionColor: "#607d8a"
					anchors.bottomMargin: 2
					clip: false
					anchors.leftMargin: 2
					Keys.onReturnPressed: {
						buttonLogon.clicked()
					}
				}
				anchors.rightMargin: 24
				border.color: "#000000"
				anchors.top: rectanglePassword.bottom
				anchors.right: parent.right
			}

			Text {
				id: textPin
				y: 177
				text: qsTr("Pin:")
				horizontalAlignment: Text.AlignRight
				anchors.verticalCenter: rectanglePin.verticalCenter
				anchors.right: rectanglePin.left
				anchors.rightMargin: 8
				anchors.left: parent.left
				anchors.leftMargin: 24
				font.bold: true
			}
		}
		Connections {
			target: humbleUser
			onAppError: {
				buttonLogon.enabled = true
				textMessage.text = humbleUser.getErrorMessage()
			}
            onCaptchaRequired: {
                buttonLogon.enabled = true
                textMessage.text = "Captcha Missing"
                Qt.createComponent("CaptchaDialog.qml").createObject(pageLogin, { })
            }
			onLoginRequired: {
				buttonLogon.enabled = true
				textMessage.text = ''
			}

			onAppSuccess: {
				console.log("logged in")

                GameDatabase.setUser(humbleCrap.getUsername())
				humbleUser.updateOrders()
				pageLogin.destroy()
			}
		}
		Component.onCompleted: {
            console.log(humbleCrap.getUsername())
            var user = humbleCrap.getUsername()
			humbleUser.setUser(user)
		}
	}
}
