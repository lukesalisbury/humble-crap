/****************************************************************************
* Copyright © 2015 Luke Salisbury
*
* This software is provided 'as-is', without any express or implied
* warranty. In no event will the authors be held liable for any damages
* arising from the use of this software.
*
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
*
* 1. The origin of this software must not be misrepresented; you must not
*    claim that you wrote the original software. If you use this software
*    in a product, an acknowledgement in the product documentation would be
*    appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
*    misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
****************************************************************************/
import QtQuick 2.0
import QtGraphicalEffects 1.0


Item {
	id: container
	property string text: '🔄'
	property string databaseIdent: ""
	property string url: ""
	property string title: " Unlabeled"
	property color colour: "#FFFFFF"
	property color hoverBackground: "#05343a"
	property color background: "#00acc1"


	signal clicked

	antialiasing: true

	width: 24
	height: 24

	Rectangle {
		id: rectangle1
		width: 20

		radius: 0
		border.width: 0
		border.color: "#000000"
		anchors.fill: parent
		color: container.background
		Text {
			id: text1
			color: container.colour
			text: container.text
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			anchors.top: parent.top
			textFormat: Text.PlainText
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
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
			onPressed: container.state = "clicked"
			onReleased: container.state = ""
			onClicked: container.clicked()
			onEntered: container.state = "hover"
			onExited: container.state = ""
		}
	}
	DropShadow {
		width: 20
		anchors.fill: rectangle1
		horizontalOffset: 2
		verticalOffset: 2
		radius: 2
		cached: true
		samples: 8
		color: "#80000000"
		source: rectangle1
	}

	Rectangle {
		id: rectangle
		x: 24
		y: 0
		width: 64
		height: 24
		color: container.hoverBackground
		opacity: 0

		Text {
			id: text2
			color: container.colour
			text: container.title
			anchors.verticalCenter: parent.verticalCenter
			font.pixelSize: 12
			opacity: 0
							anchors.bottomMargin: 6
				anchors.topMargin: 0
				horizontalAlignment: Text.AlignLeft
				verticalAlignment: Text.AlignVCenter
				anchors.leftMargin: 0
		}
	}

	states: [
		State {
			name: "clicked"

			PropertyChanges {
				target: rectangle1
				anchors.rightMargin: -1
				anchors.bottomMargin: -1
				anchors.leftMargin: 1
				anchors.topMargin: 1
			}
		},
		State {
			name: "hover"

			PropertyChanges {
				target: rectangle1
				color: container.hoverBackground
			}

			PropertyChanges {
				target: rectangle
				opacity: 1
			}

			PropertyChanges {
				target: text2

				opacity: 1
			}
		}
	]
}
