import QtQuick 2.0

Rectangle {
	id: rectangle1
	property string name: "Windows"
	signal clicked
	width: 120
	height: 40
 color: "#00000000"
	radius: 0
 clip: false
	border.width: 0

	MouseArea {
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
   style: Text.Outline
   font.pointSize: 16
   font.family: "Tahoma"
			font.bold: true
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			horizontalAlignment: Text.AlignHCenter
			styleColor: "#0a0909"
		}
	}
	states: [
		State {
			name: "hover"

			PropertyChanges {
				target: text1
	styleColor: "#9f0c0c"
	font.family: "Verdana"
	font.pointSize: 16
				anchors.verticalCenterOffset: 1
			}
		}
	]
	Transition {
		from: " "
		to: "hover"
		SequentialAnimation {
			NumberAnimation {
				target: gradientstop2
				easing.type: Easing.InQuad
				properties: "color"
				duration: 200
			}
		}
	}
}
