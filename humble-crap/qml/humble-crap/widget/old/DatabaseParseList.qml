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

import "../widget"
import "../scripts/CrapDatabase.js" as CrapDatabase

Rectangle {
	property int counter: 0
	property int total: 1
	property bool running: false
	property ParseNotication notification

	signal updateList
	signal cancel

	Timer {
		id: workerTimer
        interval: 4
		running: false
		repeat: true
		onTriggered: {
			var queryObject = CrapDatabase.queuePop()
			if (queryObject) {
				notification.count = ++counter
				CrapDatabase.runQuery(queryObject.action, queryObject.query, queryObject.data)
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
				total = CrapDatabase.queueSize()

                notification = notifications.addNotication( "ParseNotication.qml", { title: "Updating Orders", count: 0, total: total } )

				workerTimer.running = true
			} else {

				if (messageObject.queries) {
                    CrapDatabase.queueAddMultiple(messageObject)
				}
			}
		}
	}


	/* Signal */
	onUpdateList: {

		if ( !workerTimer.running )
		{
			var data = CrapDatabase.getOrders()
			total = data.length;
            console.log('Order Size', total)
            if (total) {
				workerParse.sendMessage({ data: data })
			}
		}
	}

	onCancel: {
		workerTimer.running = false
	}
}
