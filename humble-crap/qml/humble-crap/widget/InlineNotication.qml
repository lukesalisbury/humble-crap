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

Rectangle {
	id: rectangleNotication
	width: 288
	height: 48
	color: "#333333"
	radius: 1
	border.width: 0
	anchors.right: parent.right
	anchors.left: parent.left

	property string message: "Default Message"
	property int total: 0
	property int count: 0

	signal successful(string content)
	signal error(string message)
	signal refresh

	Text {
		id: textMessage
		color: "#ffffff"
		text: qsTr("Default Message")
		verticalAlignment: Text.AlignVCenter
		anchors.right: parent.right
		anchors.rightMargin: 24
		wrapMode: Text.WrapAnywhere
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 18
		anchors.left: parent.left
		anchors.leftMargin: 24
		anchors.top: parent.top
		anchors.topMargin: 18
		font.pointSize: 8
	}

	Rectangle {
		id: progressRectangle
		width: total > 0 ? (rectangleNotication.width * (count/total)) : 0
		height: 4
		color: "#1b5e20"
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0
	}

	onRefresh: {
		textMessage.text = message + " " + count + '/' + total
		progressRectangle.width = total > 0 ? (rectangleNotication.width * (count/total)) : 5
	}

	states: [
		State {
			name: "Removing"
			PropertyChanges {
				target: rectangleNotication
				opacity: 0
			}
		}
	]

	transitions: [
		Transition {
			from: "*"
			to: "Removing"
			NumberAnimation {
				properties: "opacity"
				easing.type: Easing.OutCurve
				duration: 1000
				onRunningChanged: {
					if (!running) {

					}
				}
			}
		}
	]
}
