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

Window {
	visible: true
	title: "Humble Crap"

	id: pageMainWindow
	width: 600
	height: 400
	color: "#FFFFFF"

	property string page: "games"

	signal refresh
	signal display
	signal updateOrders
	signal updateList
	signal quit
	signal parseOrders

	/* */
	Connections {
		target: humbleUser
		onOrderSuccess: {
			console.log("onOrderSuccess")
			GameDatabase.setUser(humbleUser.getUser())
			pageMainWindow.parseOrders()
		}
		onOrderError: {
			console.log("onOrderError")
		}
	}

	/* Code */
	function getActiveList()
	{
		if (pageMainWindow.page == 'audio') {
			return audioDatabaseList;
		} else if (pageMainWindow.page == 'asmjs') {
			return asmjsDatabaseList;
		} else if (pageMainWindow.page == 'games') {
			return gamesDatabaseList;
		} else if (pageMainWindow.page == 'ebook') {
			return ebookDatabaseList;
		}
		return null;
	}

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
			anchors.right: parent.right
			anchors.rightMargin: 230
			anchors.left: parent.left
			anchors.leftMargin: 0
			anchors.top: textTitle.bottom
			anchors.topMargin: 0
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0
			spacing: 2.0
			CategoryButton {
				id: categoryGames
				name: "Games"
				action: "games"
				onClicked: {
					pageMainWindow.page = action
					pageMainWindow.display()
				}
			}
			CategoryButton {
				id: categoryAudio
				name: "Audio"
				action: "audio"
				onClicked: {
					pageMainWindow.page = action
					pageMainWindow.display()
				}
			}
			CategoryButton {
				id: categoryEbook
				name: "Ebook"
				action: "ebook"
				onClicked: {
					pageMainWindow.page = action
					pageMainWindow.display()
				}
			}
			CategoryButton {
				id: categoryASMJS
				name: "ASM.js"
				action: "asmjs"
				onClicked: {
					pageMainWindow.page = action
					pageMainWindow.display()
				}
			}

			Text {
				id: updateNotice
				color: "#ffffff"
				text: "No Updates"
				font.bold: true
				anchors.verticalCenter: parent.verticalCenter
			}
		}

		ActionButton {
			id: actionButton1

			y: 9
			anchors.right: parent.right
			anchors.rightMargin: 6

			text: "Exit"
			onClicked: {
				pageMainWindow.quit()
			}
		}

		ActionButton {
			id: actionButton2
			x: -1
			y: 3
			text: "Settings"
			anchors.verticalCenter: actionButton1.verticalCenter
			anchors.rightMargin: 6
			anchors.right: actionButton1.left
			onClicked: {
				Qt.createComponent("SettingDialog.qml").createObject( pageMainWindow, {  } )
			}
		}
	}
	Flow {
		id: boxItem
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.top: boxTitle.bottom
		anchors.topMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0

		GameTab {
			visible: false
			model: gameDatabaseList
		}
		AudioTab {
			visible: false
			model: audioDatabaseList
		}
		EbookTab {
			visible: false
			model: ebookDatabaseList
		}
		AsmjsTab {
			visible: false
			model: asmjsDatabaseList
		}
	}

	NotificationArea {
		id: notifications
		anchors.fill: parent
		anchors.bottomMargin: 4
		anchors.leftMargin: 4
		property int watchCount: 0
		property int watchTotal: 0
		onWatchCountChanged: {
			if (watchTotal != 0) {
				if (watchCount == watchTotal) {
					pageMainWindow.updateList()
					watchTotal = 0
					watchCount = 0
				}
			}
		}
	}

	DatabaseParseList {
		id: parseDatabaseList
	}
	DatabaseListModel {
		id: audioDatabaseList
	}
	DatabaseListModel {
		id: asmjsDatabaseList
	}
	DatabaseListModel {
		id: gameDatabaseList
	}
	DatabaseListModel {
		id: ebookDatabaseList
	}
	WorkerScript {
		id: gameWorker
		source: "../scripts/GameOrdersWorker.js"

		onMessage: {
			//databaseList.updateCount++
		}
	}

	Timer {
		id: workerTimer
		interval: 1
		running: false
		repeat: true
		onTriggered: {
			var messageObject = GameDatabase.queuePop()
			if (messageObject) {
				GameDatabase.runQuery(messageObject.action, messageObject.query, messageObject.data)
			} else {
				running = false
			}
		}
	}

	/* Signals */
	onParseOrders: {
		var fullDownloadedPage = humbleUser.getOrders()
		GameDatabase.parseOrders(notifications, fullDownloadedPage)
	}

	onRefresh: {
		parseDatabaseList.updateList()
	}

	onUpdateOrders: {
		humbleUser.updateOrders()
	}

	onUpdateList: {
		parseDatabaseList.updateList()
	}

	onDisplay: {
		if ( getActiveList())
			getActiveList().display(pageMainWindow.page, humbleSystem.bits)
	}

	onQuit: {
		parseDatabaseList.cancel()

		if ( getActiveList())
			getActiveList().cancel()
		Qt.quit()
	}

	Component.onCompleted: {
		categoryGames.action = humbleSystem.platform
		page = "games"

		// default
		//Qt.createComponent("LoginDialog.qml").createObject(pageMainWindow, { })

		// use Cache ( Use Existing )
		GameDatabase.setUser("lukex@operamail.com")
		pageMainWindow.updateList()
	}
}
