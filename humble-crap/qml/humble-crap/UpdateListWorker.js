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

function insertSubProducts( item ) {
	var queries = [];
	if ( item.human_name ) {

		var types = "|"

		for ( var i = 0; i < item.downloads.length; i++ ) {
			types += item.downloads[i].platform + "|";

			for ( var q = 0; q < item.downloads[i].download_struct.length; q++ ) {
				var w = item.downloads[i].download_struct[q]
				if ( w.url )
				{
					queries.push( {
						'action': 'replaceDownloads',
						'query': 'REPLACE INTO DOWNLOADS (id, platform, format, version, date, torrent, url, sha1, size) VALUES(?, ?, ?,?, ?, ?, ?,?,?)',
						'data': [item.machine_name, item.downloads[i].platform, w.name, item.downloads[i].download_version_number, w.timestamp, w.url.bittorrent, w.url.web, w.sha1, w.file_size ]
					})
				}
			}
		}
		queries.push( {
			'action': 'replaceListing',
			'query': 'UPDATE LISTINGS SET product = ?, author = ?, icon = ?, type = ? WHERE ident = ?',
			'data': [ item.human_name, item.payee.human_name, item.icon, types, item.machine_name ]
		})

	} else {
		console.log( item.machine_name, "has no name")
	}

	return queries;

}


WorkerScript.onMessage = function(msg) {


	for ( var i = 0; i < msg.data.length; i++ ) {
		var obj = JSON.parse( msg.data[i].cache );
		for ( var q = 0; q < obj.subproducts.length; q++ ) {
			var item = obj.subproducts[q];
			if ( item ) {

				WorkerScript.sendMessage({ 'type': 0, 'queries': insertSubProducts(item) } )
			}
		}
		WorkerScript.sendMessage({ 'type': 1 } )
	}
}
