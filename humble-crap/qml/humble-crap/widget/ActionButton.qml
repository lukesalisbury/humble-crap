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

	property string text: "ACTION"
	property color colour: "#FFFFFF"
	property color background: "#00acc1"
	property int fontSize: 10
	property bool active: true

	signal clicked


	width: 64
	height: 20


	Rectangle {
		id: rectangleBox
		anchors.fill: parent
		color: active ? Theme.buttonBackground: Qt.tint(Theme.buttonBackground, 'gray')

		Text {
			id: text1
			color: Theme.buttonColor
			text: container.text
			anchors.fill: parent
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
			font.pointSize: 8
			font.bold: true
		}

		MouseArea {
			id: mouseBox
			anchors.rightMargin: 0
			anchors.bottomMargin: 0
			anchors.leftMargin: 0
			anchors.topMargin: 0
			hoverEnabled: true
			anchors.fill: parent
			onPressed: container.state = "clicked"
			onReleased: container.state = ""
			onClicked: {
				if ( active ) {
					container.clicked()
				}
			}
			onEntered: container.state = "hover"
			onExited:  container.state = ""
		}
	}

	// States
	states: [
		State {
			name: "clicked"

			PropertyChanges {
				target: rectangleBox
				anchors.rightMargin: -1
				anchors.bottomMargin: -1
				anchors.leftMargin: 1
				anchors.topMargin: 1
				color: active ? Theme.buttonActiveBackground: Qt.tint(Theme.buttonBackground, 'gray')
			}
		},
		State {
			name: "hover"

			PropertyChanges {
				target: rectangleBox
				color: active ? Theme.buttonHoverBackground: Qt.tint(Theme.buttonBackground, 'gray')
			}
		}
	]
}
