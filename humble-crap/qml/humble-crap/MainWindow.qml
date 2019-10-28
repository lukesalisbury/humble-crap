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
import QtQuick.Window 2.3

import "asmjs"
import "audio"
import "dialog"
import "ebook"
import "game"
import "widget"

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
		id: databaseTimer
		interval: 1000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			if ( ordersWorker.widget )
				ordersWorker.widget.refresh()
		}
	}

	Item {
		id: ordersWorker

		property InlineNotication widget: null
		property int counter: 0
		property int total: 0
		property var keys: null
		property int keysIndex: 0

		signal initiate(string message)
		signal update(string message)
		signal next
		signal finish

		onUpdate: {
			if ( this.total > this.counter) {
				if ( !this.widget )
					this.initiate(message)
				if ( this.widget ) {
					this.widget.count = ++this.counter
					this.widget.total = this.total
					if ( this.total <= this.counter)
						finish()
				}
			}
		}

		onInitiate: {
			var comp = Qt.createComponent("widget/InlineNotication.qml")
			if (comp.status === Component.Ready) {
				ordersWorker.widget = comp.createObject(pageMainDialog.notication, {message: message})
			}
		}

		onFinish: {
			if ( ordersWorker.widget ) {
				ordersWorker.widget.destroy()
				ordersWorker.widget = null;
			}
		}

		onNext: {
			if ( keys == null || keysIndex >= keys.length)
				return;

			for ( var q = 0; q < total; q++ ) {
				if ( keysIndex < keys.length ) {
					var id = humbleDownloadQueue.append(Crap.SERVER + keys[keysIndex], 'cache', '', '',true)
					humbleDownloadQueue.changeDownloadItemState(id, Prosaic.DIS.ACTIVE)
					keysIndex++
				}
			}
		}

	}

	/* C++ Connections */
	Connections {
		target: humbleUser

		onOrderSuccess: {
			console.log('Main Windows Order Success')
			updateUserOrders()
		}

		// ARGS: ident,category, url
		onSignedDownloadSuccess: {
			console.log('onSignedDownloadSuccess', ident, url)
			var id = humbleDownloadQueue.append(url, humbleUser.getUser(), ident, false)
			humbleDownloadQueue.changeDownloadItemState(id, Prosaic.DIS.ACTIVE)
		}
		// ARGS: ident,category, error
		onSignedDownloadError: {
			console.log('onSignedDownloadError', ident,error)
		}
	}

	Connections {
		target: packageHandling

		//ARGS:  ident, executable, path
		onCompleted: {
			console.log('packageHandling onCompleted', ident, executable, path)
			humbleUser.installProduct(ident, executable, path);
		}

		// ARGS: ident,message
		onFailed: {
			console.log('packageHandling onFailed', ident, message)

		}

	}

	Connections {
		property var dontcrash: null
		target: humbleDownloadQueue
		onCompleted: {
			dontcrash = pageMainWindow // BUG: The main window must be refer to or it's disappears, crashing the program.
			if (pageMainWindow === null && typeof pageMainWindow == 'undefined') {
				console.error('pageMainWindow')
			}
/*
	q["id"] = this->id;
	q["filename"] = QDir::toNativeSeparators(this->filename);
	q["url"] = this->address.toDisplayString();
	q["downloadstate"] = this->state;
	q["downloaded"] = this->downloadSize;
	q["total"] = this->fileSize;
	q["owner"] = this->owner;
	q["userKey"] = this->userKey;
	*/
			// Download returned, handle response
			var user = humbleCrap.getUsername()
			var details = humbleDownloadQueue.getItemDetail(id)
			if ( details.owner === user ) {
				//TODO Should be a file download, extract/run package
				console.log(details.userKey)
				//(QString filename, QString ident, QString category)
				packageHandling.install(details.filename, details.userKey, details.userCategory)
				/*
				  Determined file type,
				  Move/Extract/Installed File
				  Update Database for product with executablePath
				*/

			} else if ( details.content && details.file ) {
				//Should be a order info
				humbleUser.insertOrder(details.file, details.content)

				ordersWorker.update('Retrieving Orders Information ')
				//ordersWorker.next()
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
		var trove = humbleUser.getTrove()

		//console.log(orders)

		var keys = CrapOrders.parseOrdersPage(ordersWorker, orders)
		//CrapDatabase.parseTrovePage(ordersWorker, trove)
		if (keys !== false)
		{
			ordersWorker.total = 3; //keys.length; //Testing
			ordersWorker.keys = keys
			ordersWorker.keysIndex = 0;
			ordersWorker.next()
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
		ordersWorker.finish()
		if ( pageMainDialog.getModel())
			pageMainDialog.getModel().cancel()

		Qt.quit()
	}

	/* On QML Load */
	Component.onCompleted: {
		updateUserOrders()
	}

	/* Functions */


}
