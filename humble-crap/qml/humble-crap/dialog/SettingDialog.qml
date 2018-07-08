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
import QtQuick 2.0

import "../widget"

Rectangle {
	id: pageSettings
	color: "#60000000"
	opacity: 1
	z: 1
	x: 0
	y: 0
	width: 300
	height: 200
	anchors.fill: parent
	MouseArea {
		id: mousearea1
		anchors.fill: parent
		propagateComposedEvents: false

		Rectangle {
			id: dialogSettings
			x: 0
			y: 0
			width: 316
			height: 316
			color: "#ffffff"
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			z: 11

			Rectangle {
				id: rectangle1
				height: 1
				color: "#1e000000"
				border.color: "#1e000000"
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				border.width: 0
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 48
			}

			Text {
				id: textTitle
				x: 0
				y: 0
				text: qsTr("Settings")
				anchors.left: parent.left
				anchors.leftMargin: 24
				anchors.top: parent.top
				anchors.topMargin: 24
				font.pointSize: 14
			}
			DialogButton {
				id: buttonClose
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 16
				text: "Close"
				anchors.right: parent.right
				anchors.rightMargin: 32
				colour: "#8a000000"

				onClicked: {
					pageSettings.destroy()
				}
			}

			FileChooserWidget {
				id: settingPath
				anchors.right: parent.right
				anchors.rightMargin: 6
				anchors.left: parent.left
				anchors.leftMargin: 6
				title: "Content Path"
				value: humbleCrap.getValue('path.content')
				anchors.top: textTitle.bottom
				anchors.topMargin: 24
			}

			FileChooserWidget {
				id: settingCache
				anchors.right: parent.right
				anchors.rightMargin: 6
				anchors.left: parent.left
				anchors.leftMargin: 6
				title: "Cache Path"
				value: humbleCrap.getValue('path.cache')
				anchors.top: settingPath.bottom
				anchors.topMargin: 6
			}
			FileChooserWidget {
				anchors.right: parent.right
				anchors.rightMargin: 6
				anchors.left: parent.left
				anchors.leftMargin: 6
				title: "Temporary Path"
				value: humbleCrap.getValue('path.temp')
				anchors.top: settingCache.bottom
				anchors.topMargin: 6
			}
		}
	}
}
