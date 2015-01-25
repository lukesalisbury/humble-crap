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
.pragma library
.import QtQuick.LocalStorage 2.0 as Sql

var database = "HumbleBundleItems";
var queueCommands = new Array();

function queueSize( ) {
	return queueCommands.length
}

function queueAdd( messageObject ){
	queueCommands.push(messageObject);
}

function queuePop( ) {
	return queueCommands.pop();
}


function databaseQuery( query, data ) {
	var db = getDatabase()

	for (var prop in data)
		console.log(prop, "=", data[prop])

	var object = db.transaction(function (tx) {
		var results = tx.executeSql( query, data )
		console.log(results.rowsAffected)
	})


}
function getDownloadTypes( id ) {
	var db = getDatabase()
	var types = "|"

	var object = db.transaction(function (tx) {
		var results = tx.executeSql('SELECT DISTINCT platform FROM DOWNLOADS WHERE id = ?', [id] );
		for(var i = 0; i < results.rows.length; i++) {
			types += results.rows.item(i).platform + "|";
		}
	});
	return types;
}


function runQuery( action, query, data ) {
	if ( action === 'replaceListing' )
	{
		var db = getDatabase()
		var object = db.transaction(function (tx) {
			var results = tx.executeSql( query,	data )
			if ( results.rowsAffected == 0 )
			{
				tx.executeSql( 'INSERT INTO LISTINGS (product, author, icon, type, ident) VALUES (?,?,?,?,?)', data )
			}
		})
	}
}

function getOrders( ) {
	var array = new Array;
	var db = getDatabase()
	db.readTransaction(function (tx) {
		var results = tx.executeSql('SELECT id, cache FROM ORDERS')
		for ( var i = 0; i < results.rows.length; i++ ) {
			array.push(  results.rows.item(i) );
		}
	})
	return array;
}

function getListing( page, bits ) {
	var array = new Array;
	var db = getDatabase()
	db.readTransaction(function (tx) {

		var results = tx.executeSql('SELECT DISTINCT l.*, platform, format, date as release FROM LISTINGS as l,DOWNLOADS as d WHERE ident=id AND platform = "' + page + '" ORDER BY "installed" DESC, "product"')
		for ( var i = 0; i < results.rows.length; i++ ) {
			array.push( results.rows.item(i) );
		}



	})

	return array;
}

function getInfo(ident, format, platform) {
	var array = null;
	var db = getDatabase()
	db.readTransaction(function (tx) {
		var results = tx.executeSql('SELECT DISTINCT * FROM LISTINGS as l, DOWNLOADS as d WHERE ident=id AND ident = ? AND format = ? AND platform = ?', [ident, format, platform ] )

		if ( results.rows.length > 0 ) {
			array = results.rows.item(0);
		}
	})

	return array;
}

function parseDownload( id, downloads ) {
	var db = getDatabase()
	var types = "|"
	for ( var i = 0; i < downloads.length; i++ ) {
		types += downloads[i].platform + "|";

		for ( var q = 0; q < downloads[i].download_struct.length; q++ ) {
			var w = downloads[i].download_struct[q]
			if ( w.url )
			{
				var object = db.transaction(function (tx) {
					var results = tx.executeSql(
						'REPLACE INTO DOWNLOADS (id, platform, format, version, date, torrent, url, sha1, size) VALUES(?, ?, ?,?, ?, ?, ?,?,?)',
						[id, downloads[i].platform, w.name, downloads[i].download_version_number, w.timestamp, w.url.bittorrent, w.url.web, w.sha1, w.file_size ])
				})
			}
		}
	}
	return types
}

//function parseOrder( orderid, ordercache ) {
//	var db = getDatabase()
//	var obj = JSON.parse( ordercache );

//	for ( var i = 0; i < obj.subproducts.length; i++ ) {
//		var item = obj.subproducts[i];

//		var types = parseDownload( item.machine_name, item.downloads )
//		var object = db.transaction(function (tx) {
//			var results = tx.executeSql(
//				'REPLACE INTO LISTINGS (id, displayName, type) VALUES(?, ?, ?)',
//				[item.machine_name, item.human_name, types])
//		})
//	}
//}

function updateOrder( notification, orderid, ordercache ) {
	var component = notification.addNotication("DownloadNotication.qml", { "url": ordercache }, function( content ){
		var db = getDatabase()
		var object = db.transaction(function (tx) {
			var results = tx.executeSql(
						'REPLACE INTO ORDERS (id, url, cache) VALUES(?, ?, ?)',
						[orderid, ordercache, content])
		})
	})
}

function updateOrders( notification, gamekeys )
{
	var gameOrderArray = JSON.parse(gamekeys);
	if ( gameOrderArray.length ) {
		for( var value in gameOrderArray ) {
			updateOrder(notification, gameOrderArray[value], "https://www.humblebundle.com/api/v1/order/" + gameOrderArray[value] )
		}
	}
}

function parseOrders( notification, fullDownloadedPage ) {
	var keyRegEx = /gamekeys: (\[[A-Za-z0-9\", ]*\])/
	var startIndex = fullDownloadedPage.indexOf("new window.Gamelist(")
	var endIndex = fullDownloadedPage.indexOf(");\n  \n});", startIndex)
	var gameOrders = fullDownloadedPage.substring(startIndex + 10, endIndex).match(keyRegEx)
	if ( gameOrders !== null ) {
		updateOrders( notification, gameOrders[1]);
		return true
	}
	return false
}


function setUser( user ) {
	database = "HumbleBundleItems-" . user
	createDatabase();
}

function getDatabase() {
	var db = Sql.LocalStorage.openDatabaseSync(database, "1.0", "", 1000000)
	return db
}

function createDatabase() {
	var db = getDatabase()
	db.transaction( function (tx) {

		var query_orders = 'CREATE TABLE IF NOT EXISTS ORDERS("id" TEXT NO NULL UNIQUE, "url" TEXT, "cache" TEXT );';
		var query_list = 'CREATE TABLE IF NOT EXISTS LISTINGS("ident" VARCHAR PRIMARY KEY  NOT NULL  UNIQUE , "product" VARCHAR NOT NULL , "author" VARCHAR NOT NULL , "type" VARCHAR NOT NULL  DEFAULT unknown, "status" INTEGER, "icon" VARCHAR NOT NULL  DEFAULT "humble-crap64.png", "executable" VARCHAR, "location" VARCHAR, "installed" DATETIME NOT NULL DEFAULT 0);';
		var query_download = 'CREATE TABLE IF NOT EXISTS DOWNLOADS("id" VARCHAR NOT NULL , "platform" VARCHAR NOT NULL , "format" VARCHAR NOT NULL , "date" DATETIME NOT NULL  DEFAULT 0, "version" VARCHAR, "torrent" TEXT, "url" TEXT, "size" INTEGER NOT NULL  DEFAULT 0, "sha1" TEXT, PRIMARY KEY ("id", "platform", "format"));';

		tx.executeSql( query_orders );
		tx.executeSql( query_list );
		tx.executeSql( query_download );
	})
	return db
}

