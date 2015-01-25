/****************************************************************************
* Copyright (c) 2015 Luke Salisbury
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

Item {
	id: container
	property string text: "ACTION"
	property string url: ""
	property color colour: "#00acc1"

	property bool disable: false

	property int fontSize: 10

	signal clicked

	antialiasing: true

	width: 64
	height: 20

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

	onDisableChanged:
	{
		if ( disable )
			state = "Disabled"
		else
			state = ""
	}

	states: [
		State {
			name: "Pressed"

			PropertyChanges {
				target: rectangle1
				color: "#c1c1be"
   }
		},
		State {
			name: "Disabled"

			PropertyChanges {
				target: mousearea1
				hoverEnabled: false
				enabled: false
			}

			PropertyChanges {
				target: text1
				color: "#5b5f60"
			}

			PropertyChanges {
				target: rectangle1
				color: "#00242222"
			}
		},
		State {
	  name: "State2"
  }
	]
}
