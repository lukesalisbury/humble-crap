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

Qt.include("CrapCode.js")
Qt.include("ProsaicDefine.js")

var storedKeys = null
var storedKeysIndex = 0;

WorkerScript.onMessage = function(msg) {
	var status = {'message': 'Retrieving Orders Information', completed: true }

	if ( msg.keys ) {
		if ( storedKeys == null )
		{
			storedKeys = msg.keys
			storedKeysIndex = 0
			WorkerScript.sendMessage( { 'type': DEFINES.statusUpdate, 'status':  {'message': 'Retrieving Orders Information', completed: false } } )
			getNextOrder()

		}
	} else {
		updateOrder(msg.key, msg.content, status)
	}
}

function getNextOrder() {
	if ( storedKeys == null)
		return;

	if ( storedKeysIndex >= storedKeys.length )
	{
		storedKeys = null;
		return;
	}

	WorkerScript.sendMessage( { 'type': DEFINES.downloadRequest, 'url': SERVER + storedKeys[storedKeysIndex] } )

	storedKeysIndex++
}

function databaseQuery( queryObject) {
	WorkerScript.sendMessage( { 'type': DEFINES.databaseQuery, 'query': queryObject } )
}

function updateProduct( key, product, status) {
	var availableTypes = []

	// Available downloads
	if ( product.downloads ) {
		for ( var i = 0; i < product.downloads.length; i++ ) {
			availableTypes.push(product.downloads[i].platform)

			for ( var q = 0; q < product.downloads[i].download_struct.length; q++ ) {
				var w = product.downloads[i].download_struct[q]
				if ( w.url )
				{
					//(download_id, platform, format, machine_name, version, date, torrent, url, sha1, md5, size)
					var download_query = {
						'type': 'download_replace',
						'data': [
							product.machine_name,
							product.downloads[i].platform,
							w.name,
							product.downloads[i].machine_name,
							product.downloads[i].download_version_number ? product.downloads[i].download_version_number : 0,
							w.timestamp,
							w.url.bittorrent,
							w.url.web,
							w.sha1,
							w.md5,
							w.file_size
						]
					}
					databaseQuery(download_query)
				}
			}
		}
	}
	var query = {
		'type': 'product_replace',
		'data': [
			product.machine_name,
			product.human_name ? product.human_name : product.machine_name,
			product.payee.human_name ? product.payee.human_name : product.payee.machine_name,
			0,
			product.icon,
			availableTypes.join('|'),
			key
		]
	}
	databaseQuery(query)

}

function updateOrder(key, content, status ) {
	var obj = JSON.parse(content)
	if (obj.subproducts.length) {
		var query = {
			'type': 'order_replace',
			'data': [
				key,
				'',
				obj.product.machine_name,
				obj.created,
				obj.uid
			]
		}
		databaseQuery(query)
		// Loop through products
		for ( var q = 0; q < obj.subproducts.length; q++ ) {
			updateProduct(key, obj.subproducts[q], status)
		}
	}
	WorkerScript.sendMessage( { 'type': DEFINES.statusUpdate, 'status': status } )
	getNextOrder()
}

function queueOrderDownloads(keys) {
	for( var q in keys) {
		var id = humbleDownloadQueue.append(SERVER + keys[q], 'cache', '', true)
		humbleDownloadQueue.changeDownloadItemState(id, DIS.ACTIVE)
	}
}
