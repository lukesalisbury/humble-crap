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

import "../scripts/CrapTheme.js" as Theme

Rectangle {
	id: button
	width: 120
	height: 24

	radius: 0
	clip: true
	border.width: 0

	color: defaultBackground

	/* Property */
	property alias name: textName.text
	property string action: "Windows"
	property bool active: false

	property string defaultBackground: Theme.menuBackground
	property string defaultColor: Theme.menuColor

	property string hoverBackground: Theme.Primary2
	property string hoverColor: Theme.menuColor

	property string activeBackground: Theme.menuBackground
	property string activeBorder: Theme.Primary2
	property string activeColor: Theme.menuColor


	/*Signals */
	signal clicked

	/* Widget */
	MouseArea {
		id: mouseArea

		anchors.fill: parent
		hoverEnabled: true

		Text {
			id: textName
			color: button.defaultColor
			text: "ACTION"
			font.bold: true
			font.pointSize: 10
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxBorder
			height: 4
			color: button.hoverBackground
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.left: parent.left
			anchors.leftMargin: 0
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0
			opacity: 0
			z: 1
		}

		/* MouseArea Signals */
		onClicked: button.clicked()
		onEntered: parent.state = button.active ? 'hoveractive' : 'hover'
		onExited: parent.state = button.active ? 'active' : ' '
	}

	/* Signals */
	onActiveChanged: {
		button.state = button.active ? 'active' : ' '
	}

	/* States */
	states: [
		State {
			name: "hoveractive"
			PropertyChanges {
				target: textName
				font.bold: true
				color: button.activeColor
			}
			PropertyChanges {
				target: boxBorder
				color: button.defaultBackground
				opacity: 1
			}
			PropertyChanges {
				target: button
				color: button.hoverBackground
			}


		},
		State {
			name: "hover"
			PropertyChanges {
				target: textName
				color: button.hoverColor
				font.bold: true
			}
			PropertyChanges {
				target: boxBorder
				color: button.hoverBackground
				opacity: 0
			}
			PropertyChanges {
				target: button
				color: hoverBackground
			}
		},
		State {
			name: "active"
			PropertyChanges {
				target: textName
				color: button.activeColor
				font.bold: true
			}
			PropertyChanges {
				target: boxBorder
				color: button.activeBorder
				opacity: 1
			}
			PropertyChanges {
				target: button
				color: button.activeBackground
			}
		}
	]

	Transition {
		from: " "
		to: "hover"
		SequentialAnimation {
			NumberAnimation {
				target: button
				easing.type: Easing.InQuad
				properties: "opacity"
				duration: 200
			}
		}
	}
	Transition {
		from: "active"
		to: ""
		SequentialAnimation {
			NumberAnimation {
				target: button
				easing.type: Easing.InQuad
				properties: "opacity"
				duration: 200
			}
		}
	}
	Transition {
		from: "active"
		to: "hover"
		ColorAnimation {
			target: rectangle
			duration: 200
		}
	}
	Transition {
		from: "active"
		to: "hover"
		ColorAnimation {
			target: rectangle
			duration: 200
		}
	}

}
