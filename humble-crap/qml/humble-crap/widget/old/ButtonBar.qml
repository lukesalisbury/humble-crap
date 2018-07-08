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

Rectangle {

	color: "#104b9e"
    ActionButton {
        id: buttonRefresh
		width: 91
        text: qsTr("Refresh")
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 10
		anchors.top: parent.top
		anchors.topMargin: 10
		anchors.left: parent.left
		anchors.leftMargin: 10
		onClicked: {
            pageMainWindow.refresh()
		}
	}

    ActionButton {
		id: buttonQuit
		x: 300
		onClicked: Qt.quit()
		text: qsTr("Quit")
		anchors.top: parent.top
		anchors.topMargin: 10
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 10
		anchors.right: parent.right
		anchors.rightMargin: 10

	}
}
