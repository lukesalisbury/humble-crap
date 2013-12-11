import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import QtQuick.LocalStorage 2.0

Rectangle {
    id: pageMainWindow
    opacity: 1
    width: 400
    height:400

	Rectangle {
        id: boxTitle
		z: 1
		width: parent.width ? parent.width : 400
		height: 64
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






}
