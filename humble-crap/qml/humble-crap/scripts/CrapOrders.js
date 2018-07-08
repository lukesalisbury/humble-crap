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
//.pragma library

Qt.include("CrapCode.js")

var runningOrderUpdate = false // Stop it running multiple times

/*
  getItemDetail
	{
id
filename
url
downloadstate
downloaded
total
}
*/



/*
function parseDownload(id, downloads) {
	var db = getDatabase()
	var types = "|"
	for (var i = 0; i < downloads.length; i++) {
		types += downloads[i].platform + "|"

		for (var q = 0; q < downloads[i].download_struct.length; q++) {
			var w = downloads[i].download_struct[q]
			if (w.url) {
				var object = db.transaction(function (tx) {
					var results = tx.executeSql(
								'REPLACE INTO DOWNLOADS (id, platform, format, version, date, torrent, url, sha1, size) VALUES(?, ?, ?,?, ?, ?, ?,?,?)',
								[id, downloads[i].platform, w.name, downloads[i].download_version_number, w.timestamp, w.url.bittorrent, w.url.web, w.sha1, w.file_size])
				})
			}
		}
	}
	return types
}*/



function updateOrder(key, content) {
	var obj = JSON.parse(content)
	if (obj.subproducts.length) {
		var object = db.transaction(function (tx) {
			var results = tx.executeSql(
						query_orders_insert,
						[obj.gamekey, content, obj.product.machine_name, obj.created])
		})
	}
}

function updateOrders(worker, gameKeys) {
	var items = []
	if (!runningOrderUpdate) {
		var total = gameKeys.length
		var count = 0
		runningOrderUpdate = true

		if (total) {
			for (var value in gameKeys) {
				var key = gameKeys[value].gamekey
				items.push(key)
			}
		}
	}
	runningOrderUpdate = false
	return items
}

function parseOrdersPage(worker, jsonString) {
	var gameOrders = JSON.parse(jsonString)
	if (gameOrders !== null) {
		return updateOrders(worker, gameOrders)
	}
	console.log('Order Key could not be found.')
	return false
}
