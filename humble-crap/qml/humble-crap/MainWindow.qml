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

import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
import QtQuick.Window 2.0

import "asmjs"
import "audio"
import "dialog"
import "ebook"
import "game"
import "widget"

import "scripts/CrapDatabase.js" as CrapDatabase
import "scripts/CrapOrders.js" as CrapOrders
import "scripts/CrapCode.js" as Crap
import "scripts/ProsaicDefine.js" as Prosaic

Window {
	id: pageMainWindow

	visible: true
	title: "Humble Crap"

	width: 760
	height: 560
	color: "#FFFFFF"

	/* UI */
	MainDialog {
		id: pageMainDialog
		anchors.fill: parent
	}

	/* Timer */
	Timer {
		// QmlLocalStorage can not be call from WorkerScript and we don't want
		// to block the UI, so run one insert at a time
		id: databaseTimer
		interval: 1000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			CrapDatabase.queueQuery()
		}
	}


	WorkerScript {
		id: ordersWorker
		source: "scripts/OrdersWorker.js"

		property InlineNotication widget: null
		property int counter: 0
		property int total: 0

		signal initiate
		signal finish

		onMessage: {
			switch ( messageObject.type ) {
			case Crap.DEFINES.statusUpdate:
				if ( !ordersWorker.widget )
					ordersWorker.initiate()
				if ( ordersWorker.widget )
				{
					ordersWorker.widget.message = messageObject.status.message

					ordersWorker.widget.count = ++this.counter
					ordersWorker.widget.total = this.total
					if ( this.total === this.counter)
						finish()
				}
				break;
			case Crap.DEFINES.databaseQuery:
				//CrapDatabase.queueQueryExecute(messageObject.query)
				CrapDatabase.queueAdd(messageObject.query)
				break;
			case Crap.DEFINES.downloadRequest:
				var id = humbleDownloadQueue.append(messageObject.url, 'cache', '', true)
				humbleDownloadQueue.changeDownloadItemState(id, Prosaic.DIS.ACTIVE)
				break

			default:
				break;
			}

		}

		onInitiate: {
			var comp = Qt.createComponent("widget/InlineNotication.qml")
			if (comp.status === Component.Ready) {
				ordersWorker.widget = comp.createObject(pageMainDialog.notication)
			}
		}
		onFinish: {
			if ( ordersWorker.widget )
			{
				ordersWorker.widget.destroy()
				ordersWorker.widget = null;
			}
		}
	}

	/*  C++ Connections */

	Connections {
		target: humbleUser

		onOrderSuccess: {
			console.log('MainWindow', 'onOrderSuccess')
			console.log('Main Windows Order Success')
			updateUserOrders()
		}

		onSignedDownloadSuccess: {
			// ARGS: ident,url
			console.log('onSignedDownloadSuccess', ident,url)
			var id = humbleDownloadQueue.append(url, humbleUser.getUser(), ident, false)
			//humbleDownloadQueue.changeDownloadItemState(id, Prosaic.DIS.ACTIVE)
		}
		onSignedDownloadError: {
			// ARGS: ident,error
			console.log('onSignedDownloadError', ident,error)
		}
	}


	Connections {
		target: humbleDownloadQueue
		onCompleted: {
			// Download returned, handle response
			var user = humbleCrap.getUsername()
			var details = humbleDownloadQueue.getItemDetail(id)
			if ( details.owner === user ) {
				//TODO Should be a file download, extract/run package
			} else if ( details.content && details.file ) {
				//Should be a order info
				ordersWorker.sendMessage({
										key: details.file,
										content: details.content
									 })
			}
		}
		onError: {
			var user = humbleCrap.getUsername()
			var details = humbleDownloadQueue.getItemDetail(id)

			if ( details.owner === user ) {
				//TODO get new signedDownload url, and update url on id
				console.log( 'userKey', details.userKey )
				var download_settings;

			}

		}
	}

	/* Signals */
	signal updateUserOrders
	signal quitProgram
	signal logout

	onUpdateUserOrders: {
		//TODO: Handle Trove content

		// parse information
		var orders = humbleUser.getOrders()
		//var trove = humbleUser.getTrove()

		var keys = CrapOrders.parseOrdersPage(ordersWorker, orders)
		//CrapDatabase.parseTrovePage(ordersWorker, trove)
		if (keys !== false)
		{
			/* */
			ordersWorker.total = keys.length;
			//TODO: For Time being just do one order for testing (as I have alot of orders)
			//var id = humbleDownloadQueue.append(Crap.SERVER + keys[0], 'cache', '', true)
			//humbleDownloadQueue.changeDownloadItemState(id, Prosaic.DIS.ACTIVE)
			//ordersWorker.total = 1;

			//To limit downloads, wait for the prev order has been parsed
			ordersWorker.sendMessage({ keys: keys })
		}
	}

	onLogout: {
		//Clear Cookies, Close this Window and reopen InitWindow
		humbleUser.clearUserCookies();

		// Reload Login Dialog or quit prining error
		var comp = Qt.createComponent("InitWindow.qml")
		if (comp.status === Component.Ready) {
			var newobject = comp.createObject()
			pageMainWindow.close()
		} else {
			console.log(comp.errorString())
			Qt.quit()
		}
	}

	onQuitProgram: {
		//Todo: Reenable list cancel
		/*
		parseDatabaseList.cancel()
		if ( pageMainDialog.getModel())
			pageMainDialog.getModel().cancel()
		*/
		Qt.quit()
	}

	/* On QML Load */
	Component.onCompleted: {
		// Set User Database, update to the latest orders
		CrapDatabase.setUser(humbleCrap.getUsername())
		updateUserOrders()
	}

	/* Functions */
	function databaseGetListing(page, bits) {
		return CrapDatabase.getArray( 'product_list', [page] );
	}
	function databaseGetItem(ident) {
		return CrapDatabase.getRecord( 'product_info', [ident] );
	}
	function databaseGetDownloads(ident) {
		return CrapDatabase.getArray( 'product_download', [ident, 'Download', 'windows'] );
	}
}
