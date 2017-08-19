import QtQuick 2.0

import "../widget"
import "../scripts/GameDatabase.js" as ProductDatabase

Rectangle {

	property string productIdent: ''

	id: rectanglePage
	color: "#80000000"
	anchors.fill: parent

	MouseArea {
		id: modelArea
		anchors.fill: parent

		Rectangle {
			id: rectangleDialog
			x: 190
			y: 102
			width: 200
			height: 200
			color: "#ffffff"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter

			Rectangle {
				id: rectangleHeader
				x: 0
				y: 0
				width: 200
				height: 65
				color: "#ca0303"

				Text {
					id: textHeader
					color: "#ffffff"
					text: qsTr("Text")
					anchors.left: parent.left
					anchors.leftMargin: 24
					anchors.verticalCenter: parent.verticalCenter
					font.pixelSize: 24
				}
			}

			Rectangle {
				id: rectangleFooter
				x: 0
				y: 145
				width: 200
				height: 40
				color: "#ffffff"
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
					anchors.right: parent.right
					anchors.rightMargin: 24
					anchors.top: parent.top
					anchors.topMargin: 6

					onClicked: {
						rectanglePage.destroy()
					}
				}
			}
		}
	}

	Component.onCompleted: {
		database_info = getInfo()
		console.log('productIdent', productIdent, database_info)


		textHeader.text = database_info['product']
	}

	/* Function */
	function getInfo() {
		return ProductDatabase.getInfo(productIdent)
	}
}
