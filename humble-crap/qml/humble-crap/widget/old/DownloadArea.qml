/****************************************************************************
* Copyright © 2018 Luke Salisbury
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
	id: item1
	width: 100
	height: 65
	z: 10

	property int xaxis: 0

	function addNotication(widget, attributes, success ) {
		var note;

		var component = Qt.createComponent(widget)
        if (component.status === Component.Ready) {
			attributes.anchors = {
				centerIn: parent
			}
			note = component.createObject(column1, attributes)
			if ( success )
				note.successful.connect(success);
		}

		return note;
	}


	Column {
		id: column1
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0
		anchors.right: parent.right
		anchors.rightMargin: 0
		transformOrigin: Item.BottomRight
		anchors.horizontalCenter: parent.horizontalCenter
		spacing: 4

	}
}
