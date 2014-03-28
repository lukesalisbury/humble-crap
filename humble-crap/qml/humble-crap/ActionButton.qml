import QtQuick 2.0

Item {
	id: container
    property string text: "ACTION"
	property string url: ""
	property string colour: "#33aa2a"

	property int fontSize: 10

	signal clicked

	antialiasing: true

	width: 64
	height: 20

    function go()
    {
		console.log("download", url);
    }

	Rectangle {
		id: rectangle1

		radius: 7
		gradient: Gradient {
			GradientStop {
				position: 0
                color: container.colour
			}

			GradientStop {
				position: 1
                color:  Qt.darker(container.colour, 2.4)
			}
		}
		border.color: "#000000"
		anchors.fill: parent

		Text {
			id: text1
			color: "#ffffff"
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
}
