import QtQuick 2.0

Item {
	id: container
	property string text: "ACTION"
	property string url: ""
	property color colour: "#00acc1"

	property int fontSize: 10

	signal clicked

	antialiasing: true

	width: 64
	height: 20

	function go() {
		console.log("download", url)
	}

	Rectangle {
		id: rectangle1

		radius: 0
		border.width: 0
		border.color: "#000000"
		anchors.fill: parent

		Text {
			id: text1
			color: container.colour
			text: container.text
			anchors.fill: parent
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
			font.pointSize: 8
			font.bold: true
		}

		MouseArea {
			id: mousearea1
			x: 0
			y: 0
			anchors.rightMargin: 0
			anchors.bottomMargin: 0
			anchors.leftMargin: 0
			anchors.topMargin: 0
			hoverEnabled: true
			anchors.fill: parent
			onClicked: container.clicked()
		}
	}
 states: [
	 State {
		 name: "State1"
	 }
 ]
}
