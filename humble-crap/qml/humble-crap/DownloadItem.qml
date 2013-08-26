import QtQuick 2.0
import QtQuick.XmlListModel 2.0

Item {
	id: item1
	height: 62
 visible: true
	property bool installed: false
	property string listid: "x"
	property string title: "x"
	property string icon: "humble-crap64.png"
	property string date: "0"
	property string type: "x"
	property string subtitle: "x"
	property string downloadUrl: ""

	width: (parent.width ? parent.width : 400)

	onListidChanged: {
		var db = xmlModel.retrieveInfo(listid)
	}

	function updateDatabase() {
		xmlModel.insertInfo(listid, title, 0)
	}

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
		url: (parent.installed ? "/opt/FLT/FTL" : parent.downloadUrl)
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
		onDateChanged: {
			var d = new Date(parseInt(parent.date) * 1000)
			text = (parent.date ? "Updated: " + d.toDateString() : "")
		}
	}
}
