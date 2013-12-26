import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
import QtQuick.Dialogs 1.0

XmlListModel {
	property string database: "HumbleBundleItems"
	query: "/div/div[starts-with(@class,'row')]"

	XmlRole {
		name: "itemID"
		query: "@class/string()"
		isKey: true
	}

	XmlRole {
		name: "itemTitle"
		query: "div[@class='gameinfo']/div[1]/a/text()/string()"
	}

	XmlRole {
		name: "itemSubtitle"
		query: "div[@class='gameinfo']/div[2]/a/text()/string()"
	}

	XmlRole {
		name: "itemIcon"
		query: "div[@class='icn']/a/img/@src/string()"
	}

	XmlRole {
		name: "windowsDL"
		query: "div[contains(@class,'downloads windows')]/div[1]/div/a[@class='a']/@data-bt/string()"
	}
	XmlRole {
		name: "windowsDate"
		query: "div[contains(@class,'windows')]/div[1]/div/div/a[@class='dldate']/@data-timestamp/string()"
	}

	XmlRole {
		name: "linuxDL"
		query: "div[contains(@class,'downloads linux')]/div[1]/div/a[@class='a']/@data-bt/string()"
	}
	XmlRole {
		name: "linuxDate"
		query: "div[contains(@class,'linux')]/div[1]/div/div/a[@class='dldate']/@data-timestamp/string()"
	}

	XmlRole {
		name: "osxDL"
		query: "div[contains(@class,'downloads mac')]/div[1]/div/a[@class='a']/@data-bt/string()"
	}
	XmlRole {
		name: "osxDate"
		query: "div[contains(@class,'mac')]/div[1]/div/div/a[@class='dldate']/@data-timestamp/string()"
	}
	XmlRole {
		name: "ebookDL"
		query: "div[contains(@class,'downloads ebook')]/div[1]/div/a[@class='a']/@data-bt/string()"
	}
	XmlRole {
		name: "audioDL"
		query: "div[contains(@class,'downloads audio')]/div[1]/div/a[@class='a']/@data-bt/string()"
	}

	onStatusChanged: {
        if (xmlModel.status !== 1)
		{
			console.log("Status: " + xmlModel.status)
			console.log("Count: " + xmlModel.count)
		}

        if (xmlModel.status !== 3)
		{
			console.log("Error: " + xmlModel.errorString() )
		}
	}

	function createAndOpenDB() {
		var db = LocalStorage.openDatabaseSync(database, "1.0", "", 1000000)
		db.transaction(function (tx) {
			tx.executeSql('CREATE TABLE IF NOT EXISTS LISTINGS( "id" TEXT NO NULL UNIQUE, "displayName" TEXT, "installed" INTEGER DEFAULT (0), "installPath" TEXT, "executePath" TEXT , "installDate" INTEGER DEFAULT (0) );')
		})
		return db
	}

	function retrieveInfo(databaseID, subtitle) {
		var db = createAndOpenDB()
        var object
        db.readTransaction(function (tx) {
			var results = tx.executeSql(
						'SELECT * FROM LISTINGS WHERE `id` = "' + databaseID + '"')
            object = results.rows.item(0);
		})
        return object;

	}

	function insertInfo(databaseID, displayName) {

		var db = createAndOpenDB()
		var object = db.transaction(function (tx) {
			var results = tx.executeSql(
						'REPLACE INTO LISTINGS (id, displayName, installDate) VALUES(?, ?, ?)',
						[databaseID, displayName, 0])

			//console.log("esults.rowsAffected", results.rowsAffected)
		})
	}

	function setMode(databaseID, mode) {

		var db = createAndOpenDB()
		var object = db.transaction(function (tx) {
			tx.executeSql('UPDATE LISTINGS SET installed = ? WHERE id = ?',
						  [mode, databaseID])

		})
	}


	function startTorrent( databaseID, torrentFile )
	{
		var db = createAndOpenDB()

		db.transaction(function (tx) {
			tx.executeSql('UPDATE LISTINGS SET installed = ?, installPath = ?, executePath = ? WHERE id = ?',
						  [1, 'G:\\Steam\\steamapps\\common\\alan wake\\', 'G:\\Steam\\steamapps\\common\\alan wake\\AlanWake.exe', databaseID])

		})

		downloadHumble.openFile(torrentFile)
	}

	function selectPackage( databaseID, torrentFile )
	{
		var db = createAndOpenDB()

		Qt.createComponent("StartUpDialog.qml").createObject(pageMainWindow, {});
		
		


		db.transaction(function (tx) {
			tx.executeSql('UPDATE LISTINGS SET installed = ?, installPath = ?, executePath = ? WHERE id = ?',
						  [1, 'G:\\Steam\\steamapps\\common\\alan wake\\', 'G:\\Steam\\steamapps\\common\\alan wake\\AlanWake.exe', databaseID])

		})

		downloadHumble.openFile(torrentFile)
	}


	function installed(databaseID, path, executable) {
		var db = createAndOpenDB()

		db.transaction(function (tx) {
/*
			tx.executeSql('UPDATE LISTINGS SET installed = ?, installPath = ?, executePath = ? WHERE id = ?',
						  [1, 'G:\\Steam\\steamapps\\common\\alan wake\\', 'G:\\Steam\\steamapps\\common\\alan wake\\AlanWake.exe', databaseID])

			*/
		})
	}
}
