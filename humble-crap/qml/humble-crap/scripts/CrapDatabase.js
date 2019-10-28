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

// OLD CODE - to be Removed

/*
var database_connection = null
var database_name = ".HumbleBundleItems"
var username = "No@Email"

// Database Creation SQL
var query_creation = {
	orders: 'CREATE TABLE IF NOT EXISTS ORDERS(\
		"order_id" VARCHAR NOT NULL, \
		"bundle_name" VARCHAR, \
		"date" DATETIME NOT NULL DEFAULT 0, \
		"cache" BLOB, \
		"cacheversion" VARCHAR NOT NULL, \
		PRIMARY KEY ("order_id")\
	);',
	products: 'CREATE TABLE IF NOT EXISTS PRODUCTS(\
		"product_id" VARCHAR PRIMARY KEY NOT NULL UNIQUE, \
		"product" VARCHAR NOT NULL, \
		"author" VARCHAR NOT NULL, \
		"type" VARCHAR NOT NULL DEFAULT unknown, \
		"status" INTEGER, \
		"icon" VARCHAR NOT NULL DEFAULT "humble-crap64.png", \
		"executable" VARCHAR NOT NULL DEFAULT "", \
		"location" VARCHAR NOT NULL  DEFAULT "", \
		"installed" VARCHAR NOT NULL DEFAULT 0, \
		"orderkey" VARCHAR
	);',

	downloads: 'CREATE TABLE IF NOT EXISTS DOWNLOADS(\
		"download_id" VARCHAR NOT NULL, \
		"platform" VARCHAR NOT NULL, \
		"format" VARCHAR NOT NULL, \
		"date" DATETIME NOT NULL DEFAULT 0, \
		"version" VARCHAR DEFAULT 0, "torrent" TEXT, \
		"url" TEXT, "size" INTEGER NOT NULL DEFAULT 0, \
		"sha1" TEXT, "md5" TEXT, "machine_name" VARCHAR, \
		PRIMARY KEY ("download_id", "platform", "format")
	);'
}

// Database Queries
var query_list = {
	order_replace: 'REPLACE INTO ORDERS (order_id, cache, bundle_name, date, cacheversion) VALUES(?, ?, ?, ?, ?)',
	download_replace: 'REPLACE INTO DOWNLOADS (download_id, platform, format, machine_name, version, date, torrent, url, sha1, md5, size) VALUES(?, ?, ?,?, ?,?,?, ?, ?,?,?)',
	product_replace: 'REPLACE INTO PRODUCTS (product_id, product, author, status, icon, type, orderkey ) VALUES(?,?,?,?,?,?,?)',
	download_platforms: 'SELECT DISTINCT platform FROM DOWNLOADS WHERE id = ?',
	order_list: 'SELECT order_id, cache, date FROM ORDERS',
	order_set_date: 'Update ORDERS SET date = ? WHERE order_id = ?',
	product_list: 'SELECT DISTINCT product_id, product, author, orderkey, status, icon, executable, location, installed, platform, date, version FROM PRODUCTS LEFT JOIN DOWNLOADS ON product_id=download_id  WHERE platform = ?  GROUP BY product_id ORDER BY "product", date',
	product_info: 'SELECT DISTINCT * FROM PRODUCTS WHERE product_id = ?',
	product_download: 'SELECT DISTINCT * FROM PRODUCTS, DOWNLOADS WHERE product_id=download_id AND product_id = ? AND format = ? AND platform = ?'
}


function getRecord(query_name, data) {
	var db = getDatabase()
	var array = null
	db.readTransaction(function (tx) {
		var results = tx.executeSql(
					query_list[query_name],
					data)
		if (results.rows.length > 0) {
			array = results.rows.item(0)
		}
	})

	return array
}

function getArray(query_name, data) {
	var db = getDatabase()
	var array = new Array
	db.readTransaction(function (tx) {
		var results = tx.executeSql(
					query_list[query_name],
					data)
		for (var i = 0; i < results.rows.length; i++) {
			array.push(results.rows.item(i))
		}
	})

	return array
}


function setUser(user) {
	username = user
	database_connection = createDatabase()
}


function getDatabase() {
	if (!database_connection)
		database_connection = LocalStorage.openDatabaseSync(username + database_name,
														 "1.0", "", 10485760)
	return database_connection
}

function createDatabase() {

	var db = getDatabase()
	console.log('Creating Order Database for:', username, 'if needed.')
	db.transaction(function (tx) {
		tx.executeSql(query_creation.orders)
		tx.executeSql(query_creation.products)
		tx.executeSql(query_creation.downloads)
	})

	return db
}



// Database Query List
var queueCommands = []

function queueSize() {
	return queueCommands.length
}

function queueAdd(query) {
	if (query_list[query.type])
		queueCommands.push(query)
	else
		console.log('No query for', query.type)
}

function queueAddMultiple(queries) {
	for (var i = 0; i < queries.length; i++) {
		queueCommands.push(queries[i])
	}
}

function queuePop() {
	return queueCommands.pop()
}

function queueQuery() {
	var queryObject = queueCommands.pop()
	queueQueryExecute(queryObject)
}

function queueQueryExecute(queryObject) {
	if (queryObject !== undefined) {
		var db = getDatabase()

		var object = db.transaction(function (tx) {
			var query = query_list[queryObject.type]
			try {
				var results = tx.executeSql(query, queryObject.data)
				//console.log('Query Affected', results.rowsAffected)
			} catch (e) {
				console.error('queueQueryExecute', e, query)
			}
		})

	}
}
*/
