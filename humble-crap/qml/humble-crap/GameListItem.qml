import QtQuick 2.0
import QtQuick.XmlListModel 2.0

Item {
	id: item1
	height: 62
	visible: true
	property bool installed: false
	property string listid: "x"
	property string title: "x"
	property string subtitle: "x"
	property string icon: "humble-crap64.png"
	property string type: "x"
	property string downloadUrl: ""
	property string releasedate: "0"
	property string lastState: "0"
	property int buttonMode: 0


	property var downloadList: {
			   'linux': "",
			   'windows': "",
			   'osx': "",
			   'audio': "",
			   'ebook': ""
	}
	property var datesList: {
               'linux': "0",
			   'windows': "0",
			   'osx': "0",
			   'audio': "0",
			   'ebook': "0"
	}

	width: (parent.width ? parent.width : 400)

	function set(downloads, dates) {
		downloadList = downloads
		datesList = dates

		xmlModel.insertInfo(listid, title, 0)
		checkItemStatus();

		update();
	}

	function update() {

		switch (state) {
		case "linux":
			downloadUrl = downloadList['linux']
			releasedate = datesList['linux']
			break
		case "osx":
			downloadUrl = downloadList['osx']
			releasedate = datesList['osx']
			break
		case "audio":
			downloadUrl = downloadList['audio']
			releasedate = "0"
			break
		case "ebook":
			downloadUrl = downloadList['ebook']
			releasedate = "0"
			break
		default:
			downloadUrl = downloadList['windows']
			releasedate = datesList['windows']
			break
		}

		if (downloadUrl.length) {
			height = 62
			visible = true
		} else {
			height = 0
			visible = false
		}
	}

	onStateChanged: {
		update()
	}

	function playGame()
	{
	   var info = xmlModel.retrieveInfo(listid, subtitle);


		console.log( "play", info.installPath, info.executePath )
	}

	function updateGame()
	{
	   var info = xmlModel.retrieveInfo(listid, subtitle);


	   console.log( "update", info.installPath, url )
	}

	function checkItemStatus()
	{

		// "id", "displayName" "installed" "installPath" "executePath" "installDate"

		var info = xmlModel.retrieveInfo(listid, subtitle);

		var d = new Date(parseInt(releasedate) * 1000)
		var i = new Date(info.installDate)

		console.log( info.displayName, info.installed, info.installDate )

		buttonAction.colour = "#1111FF";
		buttonAction.text = "Install"
		buttonMode = 0;
		if ( d > i )
		{
			buttonAction.colour = "#FF1111";
			buttonAction.text = "Updated"
			buttonMode = 1;
		}

		if (info.installed)
		{
			textPlatform.text = "installed"
			buttonAction.colour = "#11FF11";
			buttonAction.text = "Play"
			buttonMode = 2;
		}

	}

	function updateDatabase() {}

	Image {
		id: imageIcon
		x: 0
		y: 15
		width: 32
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 15
		anchors.top: parent.top
		anchors.topMargin: 15
		sourceSize.height: 32
		sourceSize.width: 32
		fillMode: Image.PreserveAspectFit
		source: "humble-crap64.png"
	}

	ActionButton {
		id: buttonAction
		x: 232
		anchors.top: parent.top
		anchors.topMargin: 8
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 4
		url:  parent.downloadUrl
        onClicked: {
			if ( buttonMode === 2 ) // Play
			{
				parent.playGame()
			}
			else if ( buttonMode === 1 ) // Update
			{
				parent.updateGame()
			}
			else if ( buttonMode === 0 ) // Download
			{
				//parent.install()
				var filepackage = new PackageHandling

				filepackage.SelectPackage();
				downloadHumble.getFile(listid, url)

			}
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
        property string date: (parent.date ? parent.date : "")
		id: textPlatform
		x: 32
		y: 37
		visible: true

		horizontalAlignment: Text.AlignRight
		anchors.right: buttonAction.left
		anchors.rightMargin: 0
		font.pixelSize: 10
		text: ""
		onDateChanged: {
			var d = new Date(parseInt(parent.date) * 1000)
			text = (parent.date ? "Updated: " + d.toDateString() : "")
		}
	}
	states: [
		State {
			name: "linux"
		},
		State {
			name: "windows"
		},
		State {
			name: "osx"
		},
		State {
			name: "audio"
		},
		State {
			name: "ebook"
		}
	]
}
