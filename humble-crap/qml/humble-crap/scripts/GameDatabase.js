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

var serverUrl = "https://www.humblebundle.com/api/v1/order/";
var database = "HumbleBundleItems";
var username = "No@Email"

var queueCommands = [];

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
	var db = getDatabase()
	var object = db.transaction(function (tx) {
		tx.executeSql( query,	data )
	})

}



function getOrders( ) {
	var array = new Array;
	var db = getDatabase()
	db.readTransaction(function (tx) {
		var results = tx.executeSql('SELECT order_id, cache FROM USER_ORDER WHERE owner = ?', [username] )
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
		var results = tx.executeSql('SELECT DISTINCT ident, product, author, status, icon, executable, location, installed, platform, date,version FROM PRODUCTS LEFT JOIN DOWNLOADS ON ident=id  WHERE platform = ?  GROUP BY ident ORDER BY "product", date', [page])
		for ( var i = 0; i < results.rows.length; i++ ) {
			array.push( results.rows.item(i) );
		}


	})

	return array;
}

function getInfo(ident) {
	var array = null;
	var db = getDatabase()
	db.readTransaction(function (tx) {
		var results = tx.executeSql('SELECT DISTINCT * FROM PRODUCTS WHERE ident = ?', [ident ] )

		if ( results.rows.length > 0 ) {
			array = results.rows.item(0);
		}
	})

	return array;
}

function getDownloads(ident, platform) {
	var array = null;
	var db = getDatabase()
	db.readTransaction(function (tx) {
		var results = tx.executeSql('SELECT DISTINCT * FROM PRODUCTS, DOWNLOADS WHERE ident=id AND ident = ? AND format = ? AND platform = ?', [ident, platform ] )

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


function updateOrder( notificationWidget, orderid, orderDataUrl ) {
	var db = getDatabase()
	var component = notificationWidget.addNotication("DownloadNotication.qml", { "url": orderDataUrl }, function( content ){

		var obj = JSON.parse( content );
		//console.log(obj.product.machine_name);
		var object = db.transaction(function (tx) {
			var results = tx.executeSql(
						'REPLACE INTO "USER_ORDER" (order_id, owner, cache, bundle_name) VALUES(?, ?, ?, ?)',
						[orderid, username, content, obj.product.machine_name])
			notificationWidget.watchCount++
		})
	})
}


var runningOrderUpdate = false;
function updateOrders( notificationWidget, gamekeys )
{
	if ( !runningOrderUpdate )
	{
		runningOrderUpdate = true;
		var gameOrderArray = JSON.parse(gamekeys);
		notificationWidget.watchTotal = gameOrderArray.length

		if ( gameOrderArray.length ) {
			for( var value in gameOrderArray ) {
				updateOrder(notificationWidget, gameOrderArray[value], serverUrl + gameOrderArray[value] )
			}
		}
	}
	runningOrderUpdate = false;
}

function parseOrdersPage( notificationWidget, fullDownloadedPage ) {
	var keyRegEx = /var gamekeys =  (\[[A-Za-z0-9\", ]*\])/

	var gameOrders = fullDownloadedPage.match(keyRegEx)
	if ( gameOrders !== null ) {
		updateOrders( notificationWidget, gameOrders[1] );
		return true
	}
	console.log('Order Key could not be found.')
	return false
}

function setUser( user ) {
	username = user
	createDatabase();
}

function getDatabase() {
	var db = Sql.LocalStorage.openDatabaseSync(database, "1.0", "", 1000000)
	return db
}

function createDatabase() {
	var db = getDatabase()
	db.transaction( function (tx) {

		var query_orders = 'CREATE TABLE IF NOT EXISTS "USER_ORDER" ("order_id" VARCHAR NOT NULL , "owner" VARCHAR NOT NULL , "bundle_name" VARCHAR, "cache" BLOB, PRIMARY KEY ("order_id", "owner"))';
		var query_list = 'CREATE TABLE IF NOT EXISTS PRODUCTS("ident" VARCHAR PRIMARY KEY  NOT NULL  UNIQUE , "product" VARCHAR NOT NULL , "author" VARCHAR NOT NULL , "type" VARCHAR NOT NULL  DEFAULT unknown, "status" INTEGER, "icon" VARCHAR NOT NULL  DEFAULT "humble-crap64.png", "executable" VARCHAR NOT NULL DEFAULT "" , "location" VARCHAR NOT NULL  DEFAULT "" , "installed" DATETIME NOT NULL DEFAULT 0);';
		var query_download = 'CREATE TABLE IF NOT EXISTS DOWNLOADS("id" VARCHAR NOT NULL , "platform" VARCHAR NOT NULL , "format" VARCHAR NOT NULL , "date" DATETIME NOT NULL  DEFAULT 0, "version" VARCHAR, "torrent" TEXT, "url" TEXT, "size" INTEGER NOT NULL  DEFAULT 0, "sha1" TEXT, PRIMARY KEY ("id", "platform", "format"));';
		//var query_orders = 'CREATE TABLE IF NOT EXISTS "USER_ORDER" ("order_id" VARCHAR NOT NULL , "owner" VARCHAR, "cache" BLOB, "bundle_name" VARCHAR)';

		tx.executeSql( query_orders );
		tx.executeSql( query_list );
		tx.executeSql( query_download );
	})
	return db
}

