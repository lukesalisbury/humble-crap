import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
import QtQuick.Window 2.0

Window {
	visible: true
	title: "Humble Crap"

	id: pageMainWindow
	width: 600
	height: 400
	color: "#000000"

	signal refresh
	signal display
	signal contentFinished


	Rectangle {
		id: boxTitle
		z: 1
		width: parent.width ? parent.width : 400
		height: 64
		color: "#3b3535"
		opacity: 1
		visible: true
		anchors.top: parent.top
		anchors.topMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.right: parent.right
		anchors.rightMargin: 0
		gradient: Gradient {
			GradientStop {
				position: 0
				color: "#554343"
			}
			GradientStop {
				position: 0.159
				color: "#3b3434"
			}

			GradientStop {
				position: 0.621
				color: "#3b3535"
			}

			GradientStop {
				position: 0.97
				color: "#000000"
			}
		}
		Text {
			id: textTitle
			y: 0
			width: 161
			height: 29
			color: "#ffffff"
			text: qsTr("Humble Crap")
			horizontalAlignment: Text.AlignHCenter
			font.bold: true
			font.pointSize: 18
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
			CategoryButton2 {
				id: categoryGames
				name: "Games"
			}
			CategoryButton2 {
				id: categoryAudio
				name: "Audio"
			}
		}

		ActionButton {
			id: actionButton1

			y: 9
			anchors.right: parent.right
			anchors.rightMargin: 6

			text: "Exit"
			onClicked: Qt.quit()
		}
	}
	/*
	// Old Listing
	HumbleItemList {
		id: xmlModel
		function setContent(downloaded) {

			var startIndex = downloaded.indexOf("<div id='regular_download_list'")

			var endIndex = downloaded.indexOf(
						"    </div>\n  </div>\n</div>\n\n<div id='confirm-apk' class='download-popup' style='display:none'>")
			downloaded = downloaded.substring(startIndex, endIndex)

			downloaded = downloaded.replace(
						/<div class=\'[A-Za-z0-9 =_]*?\'><\/div>/g, "")
			downloaded = downloaded.replace(/&t/g, "&amp;t")
			downloaded = downloaded.replace(/\n{2,}/g, "\n")
			downloaded = downloaded.replace(/\n {1,}\n/g, "\n")
			downloaded = downloaded.replace(/<input([A-Za-z0-9 \'=_]*?)>/g, "")
			downloaded = downloaded.replace(/<a class=\'a\'\s+ download/g,
											"<a class='a'")

			downloadHumble.saveFile(downloaded, "humble.xml")
			xmlModel.xml = downloaded
		}
	}
	*/
	Item {
		id: boxItem
		anchors.right: parent.right
		anchors.rightMargin: 4
		anchors.left: parent.left
		anchors.leftMargin: 4
		anchors.top: boxTitle.bottom
		anchors.topMargin: 4
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 4
	}

	Component.onCompleted: startUp()

	Connections {
		target: downloadHumble
		onAppError: {
			buttonLogon.enabled = true
			textMessage.text = downloadHumble.getErrorMessage()
		}
		onAppSuccess: {

			pageMainWindow.display()
			pageMainWindow.refresh()
			pageLogin.destroy()
		}
	}

	onRefresh: {
		downloadHumble.updateOrdersPage()

	}

	onContentFinished: {

		var keyRegEx = /gamekeys: (\[[A-Za-z0-9\", ]*\])/
		var fullDownloadedPage = downloadHumble.getOrdersPage()

		var startIndex = fullDownloadedPage.indexOf("new window.Gamelist(")

		var endIndex = fullDownloadedPage.indexOf( ");\n  \n});\nvar flash = $('#flash');")

		var gameOrders = fullDownloadedPage.substring(startIndex+ 10, endIndex).match(keyRegEx)



		if ( gameOrders != null )
		{
			var gameOrderArray = JSON.parse(gameOrders[1]);
			console.log( gameOrderArray )
		}
	}


	onDisplay: {
		var component = Qt.createComponent("GameList.qml");
		if (component.status == Component.Ready)
		{
			var list = Qt.createComponent("GameList.qml").createObject(boxItem);

		}

	}

	function startUp() {
		Qt.createComponent("LoginDialog.qml").createObject(boxItem, {});
		//contentFinished()
	}

	Connections {
		target: downloadHumble
		onContentFinished: {
			pageMainWindow.contentFinished()
		}
	}


}
