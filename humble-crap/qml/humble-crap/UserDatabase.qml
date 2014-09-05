import QtQuick 2.0

import "GameDatabase.js" as GameDatabase


Item {
	property int updateCount: 0
	property ParseSnackbar note: null
	signal read
	signal update( ListModel model )

	signal cancel

	WorkerScript {
		id: gameWorker
		source: "GameOrders.js"

		onMessage: {
			updateCount++;
			updateNotice.text = "Updates:" + updateCount
		}
	}

	Timer {
		id: workerTimer
		interval: 2
		running: false
		repeat: true
		onTriggered: {
			if ( GameDatabase.queuePop() === false ) {
				running = false;
			} else {
				note.count++;
			}
		}
	}

	/**/
	function parseOrder( orderid, ordercache )
	{
		var obj = JSON.parse( ordercache );

		for ( var i = 0; i < obj.subproducts.length; i++ ) {
			var item = obj.subproducts[i];
			GameDatabase.queueAdd({ 'action': 'replaceListing', 'query': { 'ident': item.machine_name, 'displayName':item.human_name, 'authorName': item.payee.human_name, 'downloads':item.downloads } })
		}
	}

	function startTimer(content)
	{
		note =  notifications.addNotication("ParseSnackbar.qml", { "title": "Updating Orders", "count": 0, "total": GameDatabase.queueSize() }, function(content){ pageMainWindow.display() } )
		workerTimer.running = true
	}

	/**/
	onCancel: {
		workerTimer.running = false
	}

	onRead: {
		var data = GameDatabase.getOrders();
		var notification = notifications.addNotication("ParseSnackbar.qml", { "title": "Updating Orders", "count": 0, "total": 1 }, startTimer )
		for ( var i = 0; i < 1; i++ ) {

			parseOrder( data[i].id, data[i].cache );
			notification.count = i+1;
		}
	}

	onUpdate: {
		var data = GameDatabase.getList();
		gameWorker.sendMessage({'action': 'updateList', 'model':model, 'data': data })
	}


}
