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
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
import QtQuick.Window 2.0
import Crap.Humble.Download 1.0

import "../asmjs"
import "../audio"
import "../dialog"
import "../ebook"
import "../game"
import "../widget"

import "../scripts/GameDatabase.js" as GameDatabase
import "../scripts/FontAwesome.js" as FontAwesome

Rectangle {
	id: rectangle2
	/* UI */
	Rectangle {
		id: boxTitle
		z: 1
		height: 64
		color: "#607d8b"
		enabled: true
		border.width: 0
		opacity: 1
		visible: true
		anchors.top: parent.top
		anchors.topMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.right: parent.right
		anchors.rightMargin: 0
		Text {
			id: textTitle
			y: 0
			width: 161
			height: 29
			color: "#ffffff"
			text: qsTr("Humble Crap")
			verticalAlignment: Text.AlignVCenter
			font.pixelSize: 18
			enabled: false
			horizontalAlignment: Text.AlignHCenter
			font.bold: true
			anchors.left: parent.left
			anchors.leftMargin: 0
		}
		Text {
			id: textSubTitle
			x: 0
			y: 9
			width: 193
			height: 14
			color: "#ffffff"
			text: qsTr("Content Retrieving Application")
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
			anchors.left: textTitle.right
			anchors.leftMargin: 6
			font.pixelSize: 12
		}

		Row {
			id: menurow
			height: 26
			transformOrigin: Item.Bottom
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.left: parent.left
			anchors.leftMargin: 0
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0
			spacing: 2
			CategoryButton {
				id: categoryGames
				name: "Games"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 0
				action: "games"
				icon: FontAwesome.platform.Windows
				onClicked: {
					setActiveList(action)
				}
			}
			CategoryButton {
				id: categoryAudio
				name: "Audio"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 0
				action: "audio"
				icon: FontAwesome.icon.PlayCircle
				onClicked: {
					setActiveList(action)
				}
			}
			CategoryButton {
				id: categoryEbook
				name: "Ebook"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 0
				action: "ebook"
				icon: FontAwesome.icon.Book
				onClicked: {
					setActiveList(action)
				}
			}
			CategoryButton {
				id: categoryASMJS
				name: "ASM.js"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 0
				action: "asmjs"
				icon: FontAwesome.icon.Gamepad
				onClicked: {
					setActiveList(action)
				}
			}
		}

		ActionButton {
			id: actionButton1
			text: "Exit"
			anchors.top: parent.top
			anchors.topMargin: 6
			anchors.right: parent.right
			anchors.rightMargin: 6


			onClicked: {
				pageMainWindow.quitProgram()
			}
		}

		ActionButton {
			id: actionButton2
			text: "Settings"
			anchors.top: parent.top
			anchors.topMargin: 6
			anchors.rightMargin: 6
			anchors.right: actionButton1.left
			onClicked: {
				Qt.createComponent("SettingDialog.qml").createObject( pageMainWindow, {	} )
			}
		}
	}

	Flow {
		id: boxItem
		anchors.bottomMargin: 0
		anchors.top: boxTitle.bottom
		anchors.right: parent.right
		anchors.bottom: boxFooter.top
		anchors.left: parent.left
		anchors.topMargin: 0

		GameTab {
			id: boxGame
			visible: false
			model: gameDatabaseList
		}
		AudioTab {
			id: boxAudio
			visible: false
			model: audioDatabaseList
		}
		EbookTab {
			id: boxEbook
			visible: false
			model: ebookDatabaseList
		}
		AsmjsTab {
			id: boxAsmjs
			visible: false
			model: asmjsDatabaseList
		}
	}

	Rectangle {
		id: boxFooter
		y: 0
		height: 32
		color: "#43444a"
		transformOrigin: Item.Bottom
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0

		IconButton {
			id: buttonRefresh
			anchors.left: parent.left
			anchors.leftMargin: 6
			anchors.verticalCenter: parent.verticalCenter

			onClicked: {
				pageMainWindow.refreshListing()
			}
		}

		IconButton {
			id: buttonDownloads
			text: FontAwesome.icon.DownloadAlt
			x: 5
			y: -7
			anchors.verticalCenterOffset: 0
			anchors.leftMargin: 6
			anchors.left: buttonRefresh.right
			anchors.verticalCenter: parent.verticalCenter
		}
		IconButton {
			id: buttonUpdatesAvailable
			text: FontAwesome.icon.CircleArrowUp
			x: 5
			y: -7
			anchors.verticalCenterOffset: 0
			anchors.leftMargin: 6
			anchors.left: buttonDownloads.right
			anchors.verticalCenter: parent.verticalCenter
		}
		IconButton {
			id: buttonLoginUser
			text: FontAwesome.icon.User
			x: 5
			y: -7
			anchors.verticalCenterOffset: 0
			anchors.leftMargin: 6
			anchors.left: buttonUpdatesAvailable.right
			anchors.verticalCenter: parent.verticalCenter
			onClicked: {
				pageMainWindow.loginUser()
			}
		}
	}

	/* Functions */

	function setActiveList(page)
	{

		if (page === 'audio') {
			boxGame.visible = false;
			boxAudio.visible = true;
			boxAsmjs.visible = false;
			boxEbook.visible = false;
		} else if (page === 'asmjs') {
			boxGame.visible = false;
			boxAudio.visible = false;
			boxAsmjs.visible = true;
			boxEbook.visible = false;
		} else if (page === 'games') {
			boxGame.visible = true;
			boxAudio.visible = false;
			boxAsmjs.visible = false;
			boxEbook.visible = false;
		} else if (page === 'ebook') {
			boxGame.visible = false;
			boxAudio.visible = false;
			boxAsmjs.visible = false;
			boxEbook.visible = true;
		}
		pageMainWindow.page = page
		pageMainWindow.showListing()
	}

}
