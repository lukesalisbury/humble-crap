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

import "GameDatabase.js" as GameDatabase

Rectangle {
	property variant info
	property variant item
	id: pageItem
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
		hoverEnabled: true
		anchors.fill: parent
		propagateComposedEvents: false

		Rectangle {
			id: dialogItem
			x: 0
			y: 0
			width: 392
			height: 410
			color: "#ffffff"
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			z: 11
			Rectangle {
				id: rectangleTitle
				width: 0
				height: 80
				color: "#bf360c"
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0

				Text {
					id: textTitle
					x: 276
					y: 158
					height: 32
					color: "#ffffff"
					text: info.product
					clip: true
					wrapMode: Text.WrapAnywhere
					verticalAlignment: Text.AlignTop
					anchors.right: buttonClose.left
					anchors.rightMargin: 16
					anchors.left: imageTitle.right
					anchors.leftMargin: 16
					anchors.top: parent.top
					anchors.topMargin: 24
					font.pointSize: 14
				}

				Image {
					id: imageTitle
					width: 32
					height: 32
					anchors.top: parent.top
					anchors.topMargin: 24
					anchors.left: parent.left
					anchors.leftMargin: 24
					fillMode: Image.PreserveAspectFit
					sourceSize.height: 32
					sourceSize.width: 32
					source: info['icon'] ? info['icon'] : "humble-crap64.png"
				}

				ActionButton {
					id: buttonClose
					x: 374
					y: 36
					text: "Close"
					anchors.verticalCenter: parent.verticalCenter
					anchors.right: parent.right
					anchors.rightMargin: 24
					onClicked: {
						item.updateStatus()
						pageItem.destroy()
					}
				}
			}

			DialogButton {
				id: buttonAction
				x: 217
				y: 68
				width: 80
				text: "Download"
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 16
				anchors.right: parent.right
				anchors.rightMargin: 24
				z: 1
				opacity: 1
				onClicked: {
					Qt.openUrlExternally(info['torrent'])
				}

				Keys.onReturnPressed: {
					buttonAction.clicked()
				}

				onTextChanged: {

				}

			}

			Rectangle {
				id: rectangle1
				y: 0
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

			FileChooserButton {
				id: fileChooserLocation
				height: 46
				radius: 1
				anchors.top: textInstallTitle.bottom
				anchors.topMargin: 8
				anchors.right: parent.right
				anchors.rightMargin: 16
				anchors.left: parent.left
				anchors.leftMargin: 16
				title: "Location"
				selectExisting: false
				selectFolder: true
				visible: true
				value: info['location'] ? info['location'] : ""

				onAccepted: {
					info['location'] = value;
					GameDatabase.databaseQuery( 'UPDATE LISTINGS SET location = ? WHERE ident = ?', [ info['location'], info['ident'] ] )
				}
				onRejected: {

				}
			}

			DialogButton {
				id: buttonSecondaryAction
				y: 80
				width: 80
				height: 20
				text: "Play"
				anchors.left: parent.left
				anchors.leftMargin: 24
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 16
				z: 1
				opacity: 1

				Component.onCompleted: {
					if ( info['executable'] === null || info['executable'] === "" ) {
						disable = true
					}
				}

				onClicked: {
					if ( info['executable'] !== null && info['executable'] !== "" ) {
						humbleCrap.executeFile(info['executable'], info['location'])
					} else {
						console.log("No executable set.")
					}
				}
			}

			FileChooserButton {
				id: fileChooserExecutable
				height: 44
				radius: 1
				anchors.top: fileChooserLocation.bottom
				anchors.topMargin: 8
				anchors.right: parent.right
				anchors.rightMargin: 16
				anchors.left: parent.left
				anchors.leftMargin: 16
				title: "Executable"
				selectFolder: false
				selectExisting: true
				visible: true
				value: info['executable'] ? info['executable'] : ""

				onAccepted: {
					info['executable'] = value
					GameDatabase.databaseQuery( 'UPDATE LISTINGS SET executable = ?, installed = ? WHERE ident = ?', [ info['executable'], Date.now()/1000, info['ident'] ] )
					buttonSecondaryAction.disable = false
				}
				onRejected: {

				}
			}

			Text {
				id: textUpdateTitle
				text: "Last Updated:"
				anchors.left: parent.left
				anchors.leftMargin: 16
				anchors.top: rectangleTitle.bottom
				anchors.topMargin: 16
				font.pixelSize: 12
			}

			Text {
				id: textInstallTitle
				text: qsTr("Install Date")
				anchors.left: parent.left
				anchors.leftMargin: 16
				anchors.top: textUpdateTitle.bottom
				anchors.topMargin: 8
				font.pixelSize: 12
			}

			Text {
				property string date: info['installed']
				id: textInstall
				text: ""
				horizontalAlignment: Text.AlignRight
				anchors.top: textUpdate.bottom
				anchors.topMargin: 8
				anchors.left: textInstallTitle.right
				anchors.leftMargin: 8
				anchors.right: parent.right
				anchors.rightMargin: 16
				font.pixelSize: 12

				onDateChanged: {
					var d = new Date(parseInt(date) * 1000)
					text = (date ? d.toDateString() : "")
				}
			}

			Text {
				property string date: info['date']
				id: textUpdate
				text: ""
				horizontalAlignment: Text.AlignRight
				anchors.top: rectangleTitle.bottom
				anchors.topMargin: 16
				anchors.left: textUpdateTitle.right
				anchors.leftMargin: 8
				anchors.right: parent.right
				anchors.rightMargin: 16
				font.pixelSize: 12

				onDateChanged: {
					var d = new Date(parseInt(date) * 1000)
					text = (date ? d.toDateString() : "")

					if ( info['date'] > info['installed'] )
						buttonAction.text = "Update"

				}
			}

   Text {
	   id: textDownloadType
	   x: 317
	   y: 341
	   color: "#454343"
	   text: info['format']
	   anchors.right: parent.right
	   anchors.rightMargin: 24
	anchors.bottom: rectangle1.top
	anchors.bottomMargin: 4
	   font.pointSize: 6
   }
		}
	}

	Component.onCompleted: {
//		console.log(item)
//		for (var prop in info)
//			console.log(prop, "=", info[prop])
	}
}
