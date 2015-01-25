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


ListModel {
	property int updateCount: 0
	property ParseNotication note: null

	signal updateList
	signal display( string page, int bits )
	signal cancel

	/* function */
	function parseJSONOrder( orderID, orderCache ) {
		var obj = JSON.parse( orderCache );
		for ( var i = 0; i < obj.subproducts.length; i++ ) {
			var item = obj.subproducts[i];
			if ( item.human_name ) {
				var type = GameDatabase.getDownloadTypes(item.machine_name)

				GameDatabase.queueAdd({
										'action': 'replaceListing',
										'query': 'UPDATE LISTINGS SET product = ?, author = ?, icon = ?, type = ? WHERE ident = ?',
										'data': [ item.human_name, item.payee.human_name, item.icon, type, item.machine_name ]
									  })
			} else {
				console.log(orderID, item.machine_name, "has no name")
			}
		}
	}

	function startTimer( content ) {
		note = notifications.addNotication( "ParseNotication.qml", { "title": "Updating Products", "count": 0, "total": GameDatabase.queueSize() }, function(content){
			pageMainWindow.display()
		} )
		workerTimer.running = true
	}

	/* Signal */
	onUpdateCountChanged: {
		updateNotice.text = "Updates: " + updateCount
	}

	onCancel: {
		workerTimer.running = false
	}

	onUpdateList: {
		var data = GameDatabase.getOrders( );
		if ( data.length ) {
			var notification = notifications.addNotication( "ParseNotication.qml", { "title": "Updating Orders", "count": 0, "total": data.length }, startTimer )
			for ( var i = 0; i < data.length; i++ ) {
				parseJSONOrder( data[i].id, data[i].cache );
				notification.count = i+1;
			}
		}
	}

	onDisplay: {
		updateCount = 0;
		var data = GameDatabase.getListing( page, bits );
		gameWorker.sendMessage( {'action': 'updateList', 'model':this, 'data': data } )
	}


}
