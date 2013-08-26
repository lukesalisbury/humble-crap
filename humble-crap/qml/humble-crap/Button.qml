import QtQuick 2.0

Item {
	id: container
	property string text: ""
	property int fontSize: 10

	signal clicked

	antialiasing: true

	width: 60
	height: 40

	Rectangle {
		id: rectangle1
		color: "#273251"
		radius: 0
		border.color: "#000000"
		anchors.fill: parent

		Text {
			id: text1
			color: "#ffffff"
			text: container.text
			style: Text.Raised
			anchors.fill: parent
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			font.pointSize: container.fontSize
		}

		MouseArea {
			id: mousearea1
			hoverEnabled: true
			anchors.fill: parent
			onClicked: container.clicked()
		}
	}
}
