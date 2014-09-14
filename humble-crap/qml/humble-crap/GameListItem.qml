import QtQuick 2.0
import Crap.Humble.Package 1.0

import "GameDatabase.js" as GameDatabase

/* Button Modes */
// 0 Download
// 1 Update
// 2 install
// 3 Play


Item {
	height: 62
	width: 400
	visible: true



	property int isInstall: 0
	property string databaseIdent: "x"
	property string title: "x"
	property string subtitle: "x"
	property string icon: "humble-crap64.png"
	property string type: "x"
	property alias releaseDate: textPlatform.date
	property string installedDate: "0"
	property url path: ""
	property url executable: ""


	property string lastState: "0"
	property int buttonMode: 0

	function checkItemStatus() {

		if ( isInstall === 0 )
		{
			var info = GameDatabase.getInfo( databaseIdent, pageMainWindow.page )


			if ( info )
			{
				console.log( info.ident, info.url )
				var component = notifications.addNotication("DownloadSnackbar.qml", { "url": info.url, textMode: false, cacheFile: "temp" }, function( content ){console.log( info.ident, info.url )} )
			}

		}



	}


	function setButtonToUpdate()
	{
		buttonAction.colour = "#FF1111"
		buttonAction.text = "Updated"
		buttonMode = 1
	}

	function setButtonToSetup()
	{
		buttonAction.colour = "#FF11FF"
		buttonAction.text = "Setup"
		buttonMode = 2
	}

	function setButtonToPlay()
	{
		textPlatform.text = "installed"
		buttonAction.colour = "#11FF11"
		buttonAction.text = "Play"
		buttonMode = 3
	}

	Package {
		id: packageHandler
	}

	Image {
		id: imageIcon
		x: 0
		y: 16
		width: 32
		anchors.left: parent.left
		anchors.leftMargin: 16
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 16
		anchors.top: parent.top
		anchors.topMargin: 16
		sourceSize.height: 32
		sourceSize.width: 32
		fillMode: Image.PreserveAspectFit
		source: "humble-crap64.png"
	}

	ActionButton {
		id: buttonAction
		x: 232
		z: 2
		anchors.top: parent.top
		anchors.topMargin: 8
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 4
		databaseIdent: parent.databaseIdent
		text: "Download"
		onClicked: {
			checkItemStatus()
		}
	}

	Text {
		id: textTitle
		y: 11
		text: parent.title
		font.bold: true
		anchors.left: imageIcon.right
		anchors.leftMargin: 10
		font.pixelSize: 15
		color: "#de000000"
	}

	Text {
		id: textSubtitle
		y: 37
		text: parent.subtitle
		anchors.left: imageIcon.right
		anchors.leftMargin: 10
		font.pixelSize: 10
	}

	Text {
		property string date: "0"
		id: textPlatform
		x: 32
		y: 37
		visible: true

		horizontalAlignment: Text.AlignRight
		anchors.right: buttonAction.left
		anchors.rightMargin: 8
		font.pixelSize: 10
		text: ""
		onDateChanged: {
			var d = new Date(parseInt(date) * 1000)
			text = (date ? "Updated: " + d.toDateString() : "")
		}
	}
}
