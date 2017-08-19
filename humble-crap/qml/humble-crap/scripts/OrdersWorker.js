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

var def_query = 0
var def_finish = 1

function buildQueries( queries, product ) {

	var types = "|"

	for ( var i = 0; i < product.downloads.length; i++ ) {
		types += product.downloads[i].platform + "|";

		for ( var q = 0; q < product.downloads[i].download_struct.length; q++ ) {
			var w = product.downloads[i].download_struct[q]
			if ( w.url )
			{
				queries.push( {
					'action': 'replaceDownloads',
					'query': 'REPLACE INTO DOWNLOADS (id, platform, format, version, date, torrent, url, sha1, size) VALUES(?, ?, ?,?, ?, ?, ?,?,?)',
					'data': [product.machine_name, product.downloads[i].platform, w.name, product.downloads[i].download_version_number, w.timestamp, w.url.bittorrent, w.url.web, w.sha1, w.file_size ]
				})
			}
		}
	}
	queries.push( {
		'action': 'replaceListing',
		'query': 'REPLACE INTO PRODUCTS (product, author, icon, type, ident, status) VALUES(?,?,?,?,?,?)',
		'data': [ product.human_name ? product.human_name : product.machine_name, product.payee.human_name, product.icon, types, product.machine_name, 0 ]
	})


}


WorkerScript.onMessage = function(msg) {
	for ( var i = 0; i < msg.data.length; i++ ) {
		var obj = JSON.parse( msg.data[i].cache );
		var queries = [];
		for ( var q = 0; q < obj.subproducts.length; q++ ) {
			buildQueries(queries, obj.subproducts[q])
		}
		WorkerScript.sendMessage( { 'type': def_query, 'queries': queries } )
	}
	WorkerScript.sendMessage( { 'type': def_finish } )
}
