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

import "../scripts/CrapCode.js" as Crap
import "../scripts/ProsaicDefine.js" as Prosaic

Rectangle {

	/* Alias */
	property alias productVersion: textVersion.text
	property alias productLastPlayed: textLastPlayed.text

	/* Custom Property */
	property int requestedWidth: 320
	property int requestedHeight: 400

	property string productIdent: ''
	property string productIcon: ''
	property string productTitle: ''
	property int productStatus: 0
	property string productOrder: ''

	/* Property */
	id: rectanglePage
	color: "#80000000"
	anchors.fill: parent

	/* Widget */
	Image {
		id: imageTitle
		width: parent.width/2
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 24
		anchors.top: parent.top
		anchors.topMargin: 24
		anchors.left: parent.left
		anchors.leftMargin: 24
		fillMode: Image.PreserveAspectFit
		sourceSize.height: 64
		sourceSize.width: 64
		source: dbIcon ? dbIcon : "../images/humble-crap64.png"
	}

	MouseArea {
		id: modelArea
		anchors.fill: parent

		Rectangle {
			id: rectangleDialog
			width: Math.min(parent.width/2, requestedWidth)
			height: 240
			color: "#ffffff"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter

			Rectangle {
				id: rectangleHeader
				height: 65
				color: "#ca0303"
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				anchors.top: parent.top
				anchors.topMargin: 0

				Text {
					id: textHeader
					color: "#ffffff"
					text: productTitle
					anchors.left: parent.left
					anchors.leftMargin: 24
					anchors.verticalCenter: parent.verticalCenter
					font.pixelSize: 24
				}
			}

			Rectangle {
				id: rectangleFooter
				height: 40
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
					color: "#545454"
					anchors.right: parent.right
					anchors.rightMargin: 0
					anchors.left: parent.left
					anchors.leftMargin: 0
					anchors.top: parent.top
					anchors.topMargin: 0
				}

				DialogButton {
					id: buttonClose
					text: "Close"
					anchors.right: parent.right
					anchors.rightMargin: 24
					anchors.top: parent.top
					anchors.topMargin: 6

					onClicked: {
						rectanglePage.destroy()
					}
				}

			}

			Text {
				id: titleVersion
				text: qsTr("Version:")
				anchors.top: rectangleHeader.bottom
				anchors.topMargin: 24
				font.bold: true
				anchors.left: parent.left
				anchors.leftMargin: 24
			}

			Text {
				id: textVersion
				text: qsTr("AAA")
				anchors.top: rectangleHeader.bottom
				anchors.topMargin: 24
				anchors.right: parent.right
				anchors.rightMargin: 24
			}

			Text {
				id: titleLastPlayed
				text: qsTr("Last Played:")
				font.bold: true
				anchors.top: titleVersion.bottom
				anchors.topMargin: 8
				anchors.leftMargin: 24
				anchors.left: parent.left

			}

			Text {
				id: textLastPlayed
				text: qsTr("0")
				anchors.top: textVersion.bottom
				anchors.topMargin: 8
				anchors.rightMargin: 24
				anchors.right: parent.right
			}

			ListView {
				id: listDownloads
				height: (children.length * 40)
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.left: parent.left
				anchors.leftMargin: 0
				anchors.bottom: rectangleFooter.top
				anchors.bottomMargin: 0
				model: ListModel {

				}

				delegate: Item {

					property string downloadAddress: url
					property string machineName: machine_name
					height: 36
					width: parent.width
					Text {
						text: 'File:' + platform + ' Version: ' + version
						elide: Text.ElideMiddle
						font.bold: true

						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: 8
						anchors.right: buttonAction.left
						anchors.rightMargin: 8
					}

					ActionButton {
						id: buttonAction
						text: format

						anchors.verticalCenter: parent.verticalCenter
						anchors.right: parent.right
						anchors.rightMargin: 8

						onClicked: {
							var id = Crap.downloadProduct(url, productIdent, machineName, 0)
						}
					}
				}
				onChildrenChanged: {
					height = (children.length * 40)
				}
			}
		}
	}
	/* Signals */
	Component.onCompleted: {

		var database_info = pageMainWindow.databaseGetItem(productIdent)
		if ( database_info.status ) {
			productVersion = database_info.status ? database_info.installed : 'No Installed'
		}

		var download_list = pageMainWindow.databaseGetDownloads(productIdent)
		for ( var q = 0; q <download_list.length; q++ ) {
			listDownloads.model.append(download_list[q])
		}

	}

	/* Function */

}
