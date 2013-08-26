import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0
import QtWebKit 3.0

Rectangle {
	id: mainPage
	width: 360
	height: 360
	radius: 0

	Rectangle {
		id: titleBox
		z: 1
		width: parent.width ? parent.width : 400
		height: 64
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
				position: 0.3
				color: "#000000"
			}

			GradientStop {
				position: 0.97
				color: "#3c3535"
			}
		}
		Text {
			id: textTitle
			y: 0
			width: 360
			height: 29
			color: "#ffffff"
			text: qsTr("Humble Crap")
			horizontalAlignment: Text.AlignHCenter
			font.bold: true
			font.pointSize: 18
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.left: parent.left
			anchors.leftMargin: 0
		}
		Text {
			id: textSubTitle
			x: 0
			y: 29
			width: 360
			height: 14
			color: "#ffffff"
			text: qsTr("Content Retrieving Application")
			horizontalAlignment: Text.AlignHCenter
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.left: parent.left
			anchors.leftMargin: 0
			font.pixelSize: 12
		}

		Row {
			id: menurow
			x: 72
			width: 241
			height: 16
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0
			spacing: 2.0
			CategoryButton {
				id: categoryWindows
				name: "Windows"
			}
			CategoryButton {
				id: categoryLinux
				name: "Linux"
			}

			CategoryButton {
				id: categoryOSX
				name: "OS X"
			}
			CategoryButton {
				id: categoryAudio
				name: "Audio"
			}
			CategoryButton {
				id: categoryEbook
				name: "ebook"
			}
		}
	}



	ListView {
		id: list
		z: 0
		anchors.right: parent.right
		anchors.left: parent.left
		anchors.bottom: footer.top
		anchors.top: titleBox.bottom
		boundsBehavior: Flickable.StopAtBounds

		model: xmlModel
		delegate: GameListItem {
			title: itemTitle
			subtitle: itemSubtitle
			icon: itemIcon
			listid: itemID
			state: list.state
			Component.onCompleted: {

				set( { 'linux': linuxDL, 'windows': windowsDL, 'osx': osxDL, 'audio': audioDL, 'ebook': ebookDL }, { 'linux': linuxDate, 'windows': windowsDate, 'osx': windowsDate } )
			}
		}
	}

	Item {
		id: footer
		height: 56
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0
		z: 1
		ButtonBar {
			id: buttonarea1
   x: 0
   y: 0
   anchors.rightMargin: 0
   anchors.bottomMargin: 0
   anchors.leftMargin: 0
   anchors.topMargin: 0
			anchors.fill: parent
		}

	}

	HumbleItemList {
		id: xmlModel
		function setXML(downloaded) {
			downloadHumble.saveFile(downloaded, "full.xml")

			var startIndex = downloaded.indexOf(
						"<div id='regular_download_list'")
			var endIndex = downloaded.indexOf(
						"    </div>\n  </div>\n</div>\n\n<div id='confirm-apk' class='download-popup' style='display:none'>")
			downloaded = downloaded.substring(startIndex, endIndex)

			downloaded = downloaded.replace(
						/<div class=\'[A-Za-z0-9 =_]*?\'><\/div>/g, "")
			downloaded = downloaded.replace(/&t/g, "&amp;t")
			downloaded = downloaded.replace(/\n{2,}/g, "\n")
			downloaded = downloaded.replace(/\n\s{1,}\n/g, "\n")
			downloaded = downloaded.replace(/<input([A-Za-z0-9 \'=_]*?)>/g, "")
			downloaded = downloaded.replace(/<a class=\'a\' download/g,
											"<a class='a'")

			downloadHumble.saveFile(downloaded, "a.xml")

			xmlModel.xml = downloaded
			//xmlModel.reload()
		}

	}

	Connections {
		target: downloadHumble
		onDownloaded: {
			var downloaded = downloadHumble.getDownloadText()
			downloadHumble.saveFile(downloaded, "full.xml")

			var startIndex = downloaded.indexOf(
						"<div id='regular_download_list'")
			var endIndex = downloaded.indexOf(
						"    </div>\n  </div>\n</div>\n\n<div id='confirm-apk' class='download-popup' style='display:none'>")
			downloaded = downloaded.substring(startIndex, endIndex)

			downloaded = downloaded.replace(
						/<div class=\'[A-Za-z0-9 =_]*?\'><\/div>/g, "")
			downloaded = downloaded.replace(/&t/g, "&amp;t")
			downloaded = downloaded.replace(/\n{2,}/g, "\n")
			downloaded = downloaded.replace(/\n\s{1,}\n/g, "\n")
			downloaded = downloaded.replace(/<input([A-Za-z0-9 \'=_]*?)>/g, "")
			downloaded = downloaded.replace(/<a class=\'a\' download/g,
											"<a class='a'")

			downloadHumble.saveFile(downloaded, "a.xml")

			xmlModel.xml = downloaded
			//xmlModel.reload()
		}
	}
	Connections {
		target: categoryWindows
		onClicked: {
			list.state = "windows"
		}
	}
	Connections {
		target: categoryLinux
		onClicked: {
			list.state = "linux"
		}
	}
	Connections {
		target: categoryEbook
		onClicked: {
			list.state = "ebook"
		}
	}
	Connections {
		target: categoryAudio
		onClicked: {
			list.state = "audio"
		}
	}
	LoginBar {
		id: loginArea
		x: 39
		y: 237
		width: 281
		height: 190
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		visible: false
		opacity: 1
	}

	Connections {
		target: categoryOSX
		onClicked: {
			list.state = "osx"
		}
	}


	states: [
		State {
			name: "logon"

			PropertyChanges {
				target: loginArea
				visible: true
				opacity: 1
			}

			PropertyChanges {
				target: buttonarea1
				visible: false
			}

		}
	]

	transitions: [
		Transition {
			to: "logon"
			SequentialAnimation {
				NumberAnimation {
					target: loginArea
					properties: "opacity"
					duration: 3000
				}

			}
		},
		Transition {
			from: "logon"
			SequentialAnimation {
				NumberAnimation {
					target: loginArea
					properties: "opacity"
					duration: 3000
				}

			}
		}
	]
}
