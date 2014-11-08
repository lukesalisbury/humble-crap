import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
import QtQuick.Window 2.0
import Crap.Humble.Download 1.0

import "GameDatabase.js" as GameDatabase

Window {
	visible: true
	title: "Humble Crap"

	id: pageMainWindow
	width: 600
	height: 400
	color: "#FFFFFF"

	property string page: "games"

	signal refresh
	signal display
	signal updateOrders
	signal updateList
	signal quit
	/* */
	Connections {
		target: humbleUser
		onContentFinished: {
			console.log("contentFinished")
			pageMainWindow.updateOrders()
		}
	}

	/* UI */
	Rectangle {
		id: boxTitle
		z: 1
		height: 64
		color: "#607d8b"
		enabled: true
		border.width: 0
		opacity: 1
		visible: true
		anchors.top: parent.top
		anchors.topMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.right: parent.right
		anchors.rightMargin: 0
		Text {
			id: textTitle
			y: 0
			width: 161
			height: 29
			color: "#ffffff"
			text: qsTr("Humble Crap")
			verticalAlignment: Text.AlignVCenter
			font.pixelSize: 18
			enabled: false
			horizontalAlignment: Text.AlignHCenter
			font.bold: true
			anchors.left: parent.left
			anchors.leftMargin: 0
		}
		Text {
			id: textSubTitle
			x: 0
			y: 9
			width: 193
			height: 14
			color: "#ffffff"
			text: qsTr("Content Retrieving Application")
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
			anchors.left: textTitle.right
			anchors.leftMargin: 6
			font.pixelSize: 12
		}

		Row {
			id: menurow
			anchors.right: parent.right
			anchors.rightMargin: 230
			anchors.left: parent.left
			anchors.leftMargin: 0
			anchors.top: textTitle.bottom
			anchors.topMargin: 0
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0
			spacing: 2.0
			CategoryButton {
				id: categoryGames
				name: "Games"
				action: "games"
				onClicked: {
					pageMainWindow.page = action;
					pageMainWindow.display( )
				}
			}
			CategoryButton {
				id: categoryAudio
				name: "Audio"
				action: "audio"
				onClicked: {
					pageMainWindow.page = action;
					pageMainWindow.display( )
				}
			}
			CategoryButton {
				id: categoryEbook
				name: "Ebook"
				action: "ebook"
				onClicked: {
					pageMainWindow.page = action;
					pageMainWindow.display( )
				}
			}
			Text {
				id: updateNotice
			}
		}

		ActionButton {
			id: actionButton1

			y: 9
			anchors.right: parent.right
			anchors.rightMargin: 6

			text: "Exit"
			onClicked: {
				pageMainWindow.quit()
			}
		}
	}

	Item {
		id: boxItem
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.top: boxTitle.bottom
		anchors.topMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0

		ListView {
			id: gameList
			model: list
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			snapMode: ListView.SnapToItem
			visible: true
			boundsBehavior: Flickable.StopAtBounds

			delegate: GameListItem {
				title: product
				subtitle: author
				databaseIdent: ident
				type: type
				status: status
				path: location
				installedDate: updated
				executable: executable
				releaseDate: date


				anchors.left: parent.left
				anchors.right: parent.right
			}

			Component.onCompleted: {


			}

		}

	}

	NotificationArea {
		id: notifications
		anchors.fill: parent
		anchors.bottomMargin: 4
		anchors.leftMargin: 4
	}

	ListModel {
		id: list
	}

	UserDatabase {
		id: userDatabase
	}

	/* Signals */
	onRefresh: {

	}

	onUpdateOrders: {
		var fullDownloadedPage = humbleUser.getOrders()
		if ( GameDatabase.parseOrders( notifications, fullDownloadedPage ) ) {
			pageMainWindow.updateList( )
		}
	}

	onUpdateList: {
		userDatabase.read()
	}

	onDisplay: {
		userDatabase.update( gameList.model, pageMainWindow.page, humbleSystem.bits )
	}

	onQuit: {
		userDatabase.cancel()
		Qt.quit()
	}

	Component.onCompleted: {
		categoryGames.action = humbleSystem.platform
		page = humbleSystem.platform
		GameDatabase.createDatabase();

		// default
		//Qt.createComponent("LoginDialog.qml").createObject(pageMainWindow, {  })
		// use Cache
		pageMainWindow.updateList(  )
	}

}
