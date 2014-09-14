import QtQuick 2.0

Rectangle {
	id: rectangle1
	property string name: "Windows"
	property string action: "Windows"
	signal clicked
	width: 120
	height: 40
	color: "#00000000"
	radius: 0
	clip: false
	border.width: 0

	MouseArea {
		id: mouseArea1
		height: 48
		anchors.fill: parent
		hoverEnabled: true
		onClicked: rectangle1.clicked()
		onEntered: {
			parent.state = 'hover'
		}
		onExited: {
			parent.state = ' '
		}

		Text {
			id: text1
			color: "#ffffff"
			text: parent.parent.name
			textFormat: Text.PlainText
			style: Text.Normal
			font.pointSize: 12

			font.bold: false
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			horizontalAlignment: Text.AlignHCenter
		}
		Rectangle {
			id: rectangle2
			y: 38
			height: 2
			color: "#ffffff"
			opacity: 0
			anchors.leftMargin: 0
			anchors.left: parent.left
			anchors.rightMargin: 0
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0
		}
	}
	states: [
		State {
			name: "hover"

			PropertyChanges {
				target: rectangle2
				opacity: 1
			}
		},
		State {
			name: "active"
			PropertyChanges {
			}

			PropertyChanges {
				target: rectangle2
				color: "#fdf4c7"
				opacity: 1
			}
		}
	]
	Transition {
		from: " "
		to: "hover"
		SequentialAnimation {
			NumberAnimation {
				target: rectangle2
				easing.type: Easing.InQuad
				properties: "opacity"
				duration: 200
			}
		}
	}
}
