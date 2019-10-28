import QtQuick 2.11
import QtQuick.Window 2.3

import "dialog"

import "scripts/CrapCode.js" as Code

Window {
	id: initWindow

	height: 260
	width: 400

	color: "#dc4031"
	visible: true

	title: 'Humble Crap'

	property bool removed: false

	signal loadMainDialog

	Timer {
		id: reloadMainWidget
		interval: 5000
		running: false;
		onTriggered: loadMainDialog()
	}

	Loader {
		property string messageContent: 'Loading..'
		x: 1
		y: 1
		id: pageLoader
		source: "dialog/InitDialog.qml"
		anchors.fill: parent
		active: true
		width: 400
		height: 300
		asynchronous: true
		onLoaded: {
			if (item !== null && typeof (item) !== 'undefined' && item.requestedHeight && item.requestedWidth) {
				initWindow.setY(initWindow.y + (initWindow.height - item.requestedHeight)/2)
				initWindow.setX(initWindow.x + (initWindow.width - item.requestedWidth)/2)
				initWindow.setHeight(item.requestedHeight)
				initWindow.setWidth(item.requestedWidth)
			}
		}
	}

	/* Signals */
	onLoadMainDialog: {
		var obj = Code.qmlComponent("MainWindow.qml",null,{'visible':true})
		if ( obj ) {
			initWindow.close()
			initWindow.removed = true
			initConnections.enabled = false
			delete initWindow

		} else {
			pageLoader.messageContent = 'Failed loading the Main Dialog'
			//reloadMainWidget.start()
		}
	}

	/*  C++ Connections */
	Connections {
		id: initConnections
		target: humbleUser
		onOrderSuccess: {
			console.log('InitWindow', 'onOrderSuccess')
			if (!removed) {
				loadMainDialog()
			}
		}
		onOrderError: {
			console.log('InitWindow', 'onOrderError')
			if (!removed) {
				pageLoader.setSource("dialog/LoginDialog.qml")
			}
		}
		onLoginSuccess: {
			console.log('InitWindow', 'onLoginSuccess')
			if (!removed) {
				loadMainDialog()
			}
		}

		onSslMissing: {
			pageLoader.messageContent = 'OpenSSL is not installed, please install and restart program'
		}
	}

	Component.onCompleted: {
		/*
		 - Get past user
		 - Check if user is logged in
		 -
		*/
		var user = humbleCrap.getUsername()
		// default
		if (user.length) {
			pageLoader.messageContent = 'Login as ' + user
			humbleUser.setUser(user)
		} else {
			pageLoader.setSource("dialog/LoginDialog.qml")
		}
	}
}
