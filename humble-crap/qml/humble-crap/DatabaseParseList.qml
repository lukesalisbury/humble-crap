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

import "GameDatabase.js" as GameDatabase

Rectangle {
	property int updateCount: 1
	property ParseNotication notification
	signal updateList
	signal cancel


	function startTimer(content) {
		databaseList.updateList();
	}


	Timer {
		id: workerTimer
		interval: 1
		running: false
		repeat: true
		onTriggered: {
			var messageObject = GameDatabase.queuePop()
			if (messageObject) {
				GameDatabase.runQuery(messageObject.action,  messageObject.query, messageObject.data)
			} else {
				running = false
			}
		}
	}


	WorkerScript {
		id: parseWorker
		source: "UpdateListWorker.js"

		onMessage: {
			if (messageObject.queries) {
				for ( var i = 0; i < messageObject.queries.length; i++ ) {
					GameDatabase.queueAdd( messageObject.queries[i] )
				}
			} else {
				updateCount++;
			}
			notification.count = updateCount;
		}
	}
	/* Signal */
	onUpdateCountChanged: {
		updateNotice.text = "Updates: " + updateCount
	}

	onUpdateList: {

		var data = GameDatabase.getOrders( );
		if ( data.length ) {
			notification = notifications.addNotication( "ParseNotication.qml", { "title": "Updating Orders", "count": 0, "total": data.length}, startTimer );
			parseWorker.sendMessage( {'GameDatabase': GameDatabase, 'data': data } )

		}
	}

	onCancel: {

	}
}
