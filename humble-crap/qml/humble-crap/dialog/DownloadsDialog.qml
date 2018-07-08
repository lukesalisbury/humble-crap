import QtQuick 2.0
import "../widget"

Rectangle {
	id: pageDownloads
	color: "#60000000"
	opacity: 1
	z: 1
	x: 0
	y: 0
	width: 300
	height: 200
	anchors.fill: parent

	signal update;

	Timer {
		id: refreshListTimer
		triggeredOnStart: true
		repeat: true
		onTriggered: {
			llll = humbleDownloadQueue.items
			pageDownloads.update()
			triggeredOnStart = false //We only want this for the first run
			stop()
		}
	}

	MouseArea {
		id: mousearea1
		anchors.fill: parent
		propagateComposedEvents: false

		Rectangle {
			id: dialogDownloads
			anchors.rightMargin: 8
			anchors.leftMargin: 8
			anchors.bottomMargin: 8
			anchors.topMargin: 8
			anchors.fill: parent

			ListView {
				id: listDownloads
				anchors.topMargin: 0
				anchors.bottomMargin: 48
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				anchors.left: parent.left
				anchors.top: parent.top
				clip: true
				model: ListModel {}
				delegate: DownloadListDelegate {}
				WorkerScript {
					id: workerDownloads
					source: "../scripts/ProsaicDownloadQueue.js"
				}
			}

			ActionButton {
				id: buttonClose
				text: 'Close'
				anchors.right: parent.right
				anchors.rightMargin: 4
				anchors.left: parent.left
				anchors.leftMargin: 4

				anchors.bottom: parent.bottom
				anchors.bottomMargin: 4
				anchors.top: listDownloads.bottom
				anchors.topMargin: 8

				onClicked: {
					pageDownloads.destroy()
				}
			}
		}
	}

	/* Creation */
	Component.onCompleted: {
		update()
	}

	property variant llll: null
	onUpdate: {
		llll = humbleDownloadQueue.items
		updatelist({model: listDownloads.model, items:llll})
//		workerDownloads.sendMessage({model: listDownloads.model, items:llll})
		//workerDownloads.sendMessage({model: listDownloads.model, items: []})
	}

	/* Connections */
	Connections {
		target: humbleDownloadQueue
		onProgress: {
			refreshListTimer.start()
		}
		onError: {
			refreshListTimer.start()
		}
		onCompleted: {
			refreshListTimer.start()
		}
		onUpdated: {
			refreshListTimer.start()
		}
	}

	function updatelist(msg) {

		var h
		var items = {}

		//Existing Items
		if ( msg.model.count )
		{
			for( var g = 0; g < msg.model.count; g++ )
			{
				h = msg.model.get(g)
				items[h.id] = g
			}
		}

		//Active Items
		if ( msg.items.length )
		{
			for( var i in msg.items )
			{
				h = msg.items[i];
				if ( typeof items[h.id] === 'number' ) {
					msg.model.set(items[h.id], h, items[h.id])
					delete items[h.id]
				} else {
					msg.model.append( h )
				}
			}
			var o = 0
			for( var u in items )
			{

				msg.model.remove(items[u] + o)
				o++
			}
		} else {
			msg.model.clear()
		}
//		msg.model.sync()
	}
}
