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

import "../widget"


Rectangle {
	property variant productInfo
	property variant parentWidget

	id: dialogItem
	color: "#60000000"
	opacity: 1
	z: 200
	anchors.fill: parent

	MouseArea {
		id: modalArea
		hoverEnabled: true
		anchors.fill: parent
		propagateComposedEvents: false
		Rectangle {
			id: dialogPage
			x: 0
			y: 0
			z: 300
			width: 392
			height: 410
			color: "#ffffff"
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter

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
					text: 'info.product'
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
					source: "../images/humble-crap64.png"
				}


			}

			Rectangle {
				id: rectangleDownloads
				width: 392
				height: 90
				color: "#000000"
				anchors.bottom: rectangleFooter.top
				anchors.bottomMargin: 0

				Rectangle {
					id: rectangleDownloadList
					color: "#ffffff"
					anchors.bottom: parent.bottom
					anchors.bottomMargin: 0
					anchors.right: parent.right
					anchors.rightMargin: 0
					anchors.left: parent.left
					anchors.leftMargin: 0
					anchors.top: parent.top
					anchors.topMargin: 16
				}

				Text {
					id: textDownload
					color: "#ffffff"
					text: qsTr("Downloads")
					font.bold: true
					anchors.horizontalCenter: parent.horizontalCenter
					horizontalAlignment: Text.AlignHCenter
					font.pixelSize: 12
				}
			}

			Rectangle {
				id: rectangleFooter
				height: 43
				color: "#ffffff"
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				anchors.bottom: parent.bottom
				anchors.bottomMargin: 0

				Rectangle {
					id: rectangleFooterBorder
					height: 1
					color: "#1e000000"
					anchors.top: parent.top
					anchors.topMargin: 0
					anchors.right: parent.right
					anchors.rightMargin: 0
					anchors.left: parent.left
					anchors.leftMargin: 0
				}

				DialogButton {
					id: buttonSecondaryAction
					width: 80
					height: 20
					text: "Play"
					anchors.top: parent.top
					anchors.topMargin: 8
					anchors.left: parent.left
					anchors.leftMargin: 24
					z: 1
					opacity: 1

					Component.onCompleted: {

						//if ( info['executable'] === null || info['executable'] === "" ) {
						//	disable = true
						//}
					}

					onClicked: {

						//if ( info['executable'] !== null && info['executable'] !== "" ) {
						//	humbleCrap.executeFile(info['executable'], info['location'])
						//} else {
						//	console.log("No executable set.")
						//}
					}
				}
				DialogButton {
					id: buttonCloseAction
					width: 80
					height: 20
					text: "Close"
					anchors.right: parent.right
					anchors.rightMargin: 24
					anchors.top: parent.top
					anchors.topMargin: 8
					z: 1
					opacity: 1
					onClicked: {
						dialogItem.destroy()
					}
				}

			}
		}
	}

}
