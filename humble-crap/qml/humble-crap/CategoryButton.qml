import QtQuick 2.0

Rectangle {
	id: rectangle1
	property string name: "Windows"

	signal clicked
	width: 48
	height: 14
	radius: 0
	gradient: Gradient {
		GradientStop {
			id: gradientstop1
			position: 0
			color: "#f34949"
		}

		GradientStop {
			id: gradientstop2
			position: 1
			color: "#f34949"
		}
	}

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
			font.bold: true
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			horizontalAlignment: Text.AlignHCenter
			styleColor: "#0b0a0a"
			font.pixelSize: 8
		}
	}
	states: [
		State {
			name: "hover"

			PropertyChanges {
				target: gradientstop1
				position: 0
				color: "#f34949"
			}

			PropertyChanges {
				target: gradientstop2
				position: 1
				color: "#491b1b"
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
