/****************************************************************************
* Copyright © Luke Salisbury
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
import QtQuick 2.11
import QtGraphicalEffects 1.0

import "../scripts/CrapTheme.js" as Theme

Item {
	id: container

	property string text: '🔄'
	property string title: " Unlabeled"

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
		color: Theme.buttonBackground

		Text {
			id: text1

			text: container.text

			color: Theme.buttonColor
			font.pixelSize: Theme.buttonIconSize
			font.family: Theme.buttonFontFamily
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

			hoverEnabled: true
			anchors.fill: parent

			onPressed: container.state = "clicked"
			onReleased: container.state = ""
			onClicked: container.clicked()
			onEntered: container.state = "hover"
			onExited: container.state = ""
		}
	}

	Rectangle {
		id: rectangle2
		x: 24
		y: 0
		width: 64
		height: 24
		color: Theme.buttonBackground
		opacity: 0

		Text {
			id: text2

			text: container.title
			anchors.verticalCenter: parent.verticalCenter
			color: Theme.buttonColor
			font.pointSize: Theme.buttonFontPointSize
			font.family: Theme.buttonFontFamily
			opacity: 1
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
				target: container
			}
			PropertyChanges {
				target: rectangle1
				anchors.rightMargin: -1
				anchors.bottomMargin: -1
				anchors.leftMargin: 1
				anchors.topMargin: 1
				color: Theme.buttonActiveBackground
			}
			PropertyChanges {
				target: rectangle2
				color: Theme.buttonActiveBackground
				opacity: 1
				x: 25
				y: 1
			}
		},
		State {
			name: "hover"

			PropertyChanges {
				target: rectangle1
				color: Theme.buttonHoverBackground
			}

			PropertyChanges {
				target: rectangle2
				color: Theme.buttonHoverBackground
				opacity: 1
			}

			PropertyChanges {
				target: text2
				opacity: 1
			}
		}
	]

}
