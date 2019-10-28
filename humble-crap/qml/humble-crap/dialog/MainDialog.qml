/****************************************************************************
* Copyright © Luke Salisbury
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
import QtQuick 2.11
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
import QtQuick.Window 2.0

import "../asmjs"
import "../audio"
import "../dialog"
import "../ebook"
import "../game"
import "../widget"


import "../scripts/CrapOrders.js" as CrapOrders
import "../scripts/CrapCode.js" as Code
import "../scripts/CrapTheme.js" as Theme

Rectangle {
	id: baseWidget

	property string page: "games"
	property string platform: "windows"
	property NotificationArea notication: windowNotifications


	/* UI */
	Rectangle {
		id: boxTitle
		z: 1
		height: 80
		color: Theme.headerBackground
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
			width: 166
			height: 29
			color: Theme.headerColor
			text: qsTr("Humble Crap")
			anchors.top: parent.top
			anchors.topMargin: 8
			font.family: "Verdana"
			verticalAlignment: Text.AlignVCenter
			font.pixelSize: 18
			enabled: false
			horizontalAlignment: Text.AlignLeft
			font.bold: true
			anchors.left: parent.left
			anchors.leftMargin: 8
		}
		Text {
			id: textSubTitle
			x: 0
			width: 275
			height: 14
			color: Theme.headerColor
			text: qsTr("Humble Bundle Content Retrieving Application")
			anchors.top: textTitle.bottom
			anchors.topMargin: -8
			font.family: "Verdana"
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignLeft
			anchors.left: parent.left
			anchors.leftMargin: 8
			font.pixelSize: 9
		}
		ActionButton {
			x: 568
			text: "Exit"
			anchors.right: parent.right
			anchors.rightMargin: 8
			anchors.top: parent.top
			anchors.topMargin: 8
			onClicked: {
				Qt.quit()
			}
		}

		Rectangle {
			id: boxMenu
			height: 24
			color: Theme.menuBackground
			anchors.left: parent.left
			anchors.leftMargin: 0
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0

			Row {
				id: menurow
				x: 154
				y: -2
				height: 26
				layoutDirection: Qt.LeftToRight
				transformOrigin: Item.Bottom
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 0
				spacing: 2
				CategoryButton {
					id: categoryGames
					name: "Games"
					anchors.bottom: parent.bottom
					anchors.bottomMargin: 0
					action: "games"
					onClicked: {
						setActiveList(action)
						this.state = 'active'
					}
				}
				CategoryButton {
					id: categoryAudio
					name: "Audio"
					anchors.bottom: parent.bottom
					anchors.bottomMargin: 0
					action: "audio"
					onClicked: {
						setActiveList(action)
					}
				}
				CategoryButton {
					id: categoryEbook
					name: "E-Books"
					anchors.bottom: parent.bottom
					anchors.bottomMargin: 0
					action: "ebook"
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
					onClicked: {
						setActiveList(action)
					}
				}
				CategoryButton {
					id: categoryTrove
					name: "Trove"
					anchors.bottom: parent.bottom
					anchors.bottomMargin: 0
					action: "trove"
					onClicked: {
						setActiveList(action)
					}
				}
			}
		}

	}

	Flow {
		id: boxItem
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0
		anchors.top: boxTitle.bottom
		anchors.topMargin: 0
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: boxFooter.right
		anchors.leftMargin: 0

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
		AsmjsTab {
			id: boxTrove
			visible: false
			model: troveDatabaseList
		}
	}

	NotificationArea {
		id: windowNotifications
		anchors.fill: boxItem
		anchors.rightMargin: 24
		anchors.leftMargin: 24
		anchors.bottomMargin: 0

	}

	Rectangle {
		id: boxFooter
		width: 40
		height: 0
		color: Theme.sideBackground
		anchors.top: boxTitle.bottom
		anchors.topMargin: 0
		transformOrigin: Item.Bottom
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0

		IconButton {
			id: buttonRefresh
			title: 'Refresh'
			width: 24
			height: 24
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: buttonSettings.bottom
			anchors.topMargin: 6

			onClicked: {
				humbleUser.updateOrders()
			}
		}

		IconButton {
			id: buttonDownloads
			text: '📥'
			title: 'Downloads'
			anchors.horizontalCenterOffset: 0
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: buttonRefresh.bottom
			anchors.topMargin: 6
			width: 24
			height: 24
			onClicked: {
				Code.qmlComponent("dialog/DownloadsDialog.qml", pageMainWindow, {})
			}

		}
		IconButton {
			id: buttonUpdatesAvailable
			text: '📬'
			title: 'Updates'
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: buttonDownloads.bottom
			anchors.topMargin: 6
			width: 24
			height: 24

		}
		IconButton {
			id: buttonLoginUser
			text: '❌'
			title: 'Log out'
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: buttonUpdatesAvailable.bottom
			anchors.topMargin: 6
			width: 24
			height: 24

			onClicked: {
				pageMainWindow.logout()
			}
		}

		IconButton {
			id: buttonSettings
			text: '⚙️'
			title: 'Setting'
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 6
			width: 24
			height: 24

			onClicked: {
				Code.qmlComponent("dialog/SettingDialog.qml", pageMainWindow, {})
			}
		}
	}

	/* */
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
	DatabaseListModel {
		id: troveDatabaseList
	}
	WorkerScript {
		id: listWorker
		source: "../scripts/ProductsWorker.js"
	}

	/* signal */
	signal showList;
	onShowList: {

		var dontcrash = pageMainWindow // The main window must be refer to or it's disappears, crashing the program.
		if (pageMainWindow === null && typeof pageMainWindow == 'undefined') {
			console.error('pageMainWindow')
		}
		var activeList = pageMainDialog.currentModel()
		//console.log('onShowList', dontcrash, activeList)
		if ( activeList )
		{
			var data = humbleUser.getItems( page === 'games' ? humbleSystem.platform : page, humbleSystem.bits );
			//console.log('humbleUser.getItems', data.length, pageMainDialog)
			listWorker.sendMessage( {'action': 'updateList', 'model': activeList, 'data': data } )
		}

	}

	Component.onCompleted: {
		setActiveList(page)
	}

	/* Functions */
	property var listings: {
		"games": { 'menu': categoryGames, 'list': boxGame},
		"audio": { 'menu': categoryAudio, 'list': boxAudio},
		"ebook": { 'menu': categoryEbook, 'list': boxEbook},
		"asmjs": { 'menu': categoryASMJS, 'list': boxAsmjs},
		"trove": { 'menu': categoryTrove, 'list': boxTrove}
	}

	function markList(activeList) {

		for( var w in listings ) {
			listings[w].menu.active = listings[w].list.visible = ( w === activeList )
		}
		page = activeList
	}

	function setActiveList(activeList)
	{
		if ( page !== activeList) {
			markList(activeList)
			showList()
		}
	}

	function currentModel() {
		if ( listings[page] ) {
			return listings[page].list.model;
		}
		return 0;
	}

}

/*##^## Designer {
	D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
