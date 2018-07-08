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


Rectangle {
    id: button
    width: 120
    height: 24
    color: "#00000000"
    radius: 0
    clip: false
    border.width: 0

    property alias name: textName.text
    property string action: "Windows"
	property bool active: false

    signal clicked

    MouseArea {
        id: mouseArea1

        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
        onEntered: {
			parent.state = button.active ? 'hover active' : 'hover'
        }
        onExited: {
			parent.state = button.active ? 'active' : ' '
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

		Rectangle {
			id: boxBorder
			height: 2
			color: "#1e1e1e"
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.left: parent.left
			anchors.leftMargin: 0
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 0
			opacity: 0
		}
	}
	states: [
		State {
			name: "hover"
            PropertyChanges {
                target: textName
                font.bold: true
			}

			PropertyChanges {
				target: boxBorder
				color: "#ffffff"
				opacity: 1
			}
        },
        State {
            name: "active"
            PropertyChanges {
                target: textName
                font.bold: true
			}

			PropertyChanges {
				target: boxBorder
				color: "#003300"
				opacity: 1
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
