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

import "../widget"
import "../scripts/GameDatabase.js" as GameDatabase

Rectangle {
	property int counter: 0
	property int total: 1
	property bool running: false
	property ParseNotication notification

	signal updateList
	signal cancel


	Timer {
		id: workerTimer
		interval: 10
		running: false
		repeat: true
		onTriggered: {
			var queryObject = GameDatabase.queuePop()
			if (queryObject) {
				notification.count = ++counter
				GameDatabase.runQuery(queryObject.action, queryObject.query, queryObject.data)
			} else {
				running = false
				pageMainWindow.showListing()
			}
		}
	}

	WorkerScript {
		id: workerParse
		source: "../scripts/OrdersWorker.js"

		onMessage: {
			if (messageObject.type === 1) {
				counter = 0
				total = GameDatabase.queueSize()

				//  addNotication(widget, attributes, success )
				notification = notifications.addNotication( "ParseNotication.qml", { title: "Updating Orders", count: 0, total: total } )

				workerTimer.running = true
			} else {

				if (messageObject.queries) {
					for (var i = 0; i < messageObject.queries.length; i++) {
						GameDatabase.queueAdd( messageObject.queries[i] )
					}
				}
			}
		}
	}


	/* Signal */
	onUpdateList: {

		if ( !workerTimer.running )
		{
			var data = GameDatabase.getOrders()
			total = data.length;

			if (total) {
				workerParse.sendMessage({ data: data })
			}
		}
	}

	onCancel: {
		workerTimer.running = false
	}
}
