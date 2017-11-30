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
    width: 760
    height: 560
	color: "#FFFFFF"

	property string page: "games"
	property string platform: "windows"

	property alias list: listWorker

	signal refreshListing
	signal showListing
	signal parseOrders
	signal loginUser

	signal quitProgram

	/*  C++ Connectgions */
	Connections {
		target: humbleUser
		onOrderSuccess: {

			pageMainWindow.parseOrders()
		}
		onOrderError: {
		}
	}

	/* UI */
	MainDialog {
		id: pageMainDialog
		anchors.fill: parent
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
					pageMainWindow.refreshListing()
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
	/* Timer */
	WorkerScript {
		id: listWorker
		source: "../scripts/ProductsWorker.js"

		onMessage: {
		}
	}


	/* Signals */
	onParseOrders: {
		if ( !GameDatabase.parseOrdersPage(notifications, humbleUser.getOrders()) )
		{
			Qt.createComponent("ErrorDialog.qml").createObject(pageMainWindow, { message: 'Order Keys could not be found. Invalid Login or humblebundle.com has changed'})
		}
		else
		{
			parseDatabaseList.updateList()
		}
	}

	onRefreshListing: {
		parseDatabaseList.updateList()
	}

	onShowListing: {
		var activeList = getActiveList()
		if ( activeList )
		{
			platform = pageMainWindow.page == 'games' ? humbleSystem.platform : pageMainWindow.page

			var data = GameDatabase.getListing( platform, humbleSystem.bits );
			listWorker.sendMessage( {'action': 'updateList', 'model':activeList, 'data': data } )

		}
	}

	onQuitProgram: {
		parseDatabaseList.cancel()
		if ( getActiveList())
			getActiveList().cancel()
		Qt.quit()
	}

	onLoginUser: {
		Qt.createComponent("LoginDialog.qml").createObject(pageMainWindow, { })
	}

	Component.onCompleted: {
		platform = humbleSystem.platform
		page = "games"

		// default
		pageMainWindow.loginUser()

		// use Cache ( Use Existing )
		//GameDatabase.setUser("test@email")
		//pageMainWindow.showListing()

		// use Cache ( Rebuilt )
		//GameDatabase.setUser("test@email")
		//pageMainWindow.parseOrders()

	}

	/* Code */
	function getActiveList()
	{
		if (pageMainWindow.page == 'audio') {
			return audioDatabaseList;
		} else if (pageMainWindow.page == 'asmjs') {
			return asmjsDatabaseList;
		} else if (pageMainWindow.page == 'games') {
			return gameDatabaseList
		} else if (pageMainWindow.page == 'ebook') {
			return ebookDatabaseList;
		}
		return null;
	}

}
