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
import QtGraphicalEffects 1.0

import "../scripts/FontAwesome.js" as FontAwesome

Rectangle {
	id: button
	property alias name: textName.text
	property string action: "Windows"
	property alias icon: textIcon.text

	signal clicked
	width: 120
	height: 24
	color: "#80a03131"
	radius: 0
	clip: false
	border.width: 0

	MouseArea {
		id: mouseArea1
		height: 48
		anchors.fill: parent
		hoverEnabled: true
		onClicked: button.clicked()
		onEntered: {
			parent.state = 'hover'
		}
		onExited: {
			parent.state = ' '
		}

		Text {
			id: textName
			color: "#ffffff"
			text: "Windows"
			font.bold: true
			font.pointSize: 10
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			horizontalAlignment: Text.AlignHCenter
		}
		DropShadow {
			radius: 2
			transparentBorder: false
			verticalOffset: 2
			horizontalOffset: 2
			samples: 8
			cached: true
			fast: true
			source: textName
		}

		Text {
			id: textIcon
			x: 14
			y: 18
			color: "#ffffff"
			text: FontAwesome.platform.Windows
			font.pointSize: 12
			anchors.verticalCenter: textName.verticalCenter
			anchors.right: textName.left
			anchors.rightMargin: 2
			font.family: FontAwesome.family
		}
	}
	states: [
		State {
			name: "hover"

			PropertyChanges {
				target: button
				color: "#000000"
			}

			PropertyChanges {
				target: textIcon
				color: "#ffffff"
			}

			PropertyChanges {
				target: textName
				font.bold: true
				font.pointSize: 10
   }
		},
		State {
			name: "active"
			PropertyChanges {
			}

			PropertyChanges {
				target: textName
				color: "#000000"
				font.bold: true
				font.pointSize: 10
			}

			PropertyChanges {
				target: button
				color: "#ffffff"
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
