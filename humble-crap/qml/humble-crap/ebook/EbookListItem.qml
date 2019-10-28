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
import "../dialog"

import "../scripts/CrapCode.js" as Code

BaseListItem {
	property alias dbProduct: textTitle.text
	property alias dbAuthor: textSubtitle.text
	property alias dbIcon: imageIcon.source
	property alias buttonBackground: buttonAction.background
	property alias buttonText: buttonAction.text

	/* Widgets */


	Image {
		id: imageIcon
		width: 46
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.top: parent.top
		anchors.topMargin: 8

		sourceSize.height: 64
		sourceSize.width: 64
		fillMode: Image.PreserveAspectFit
		source: "../images/humble-crap64.png"
	}

	Text {
		id: textTitle

		anchors.left: imageIcon.right
		anchors.leftMargin: 10
		anchors.top: parent.top
		anchors.topMargin: 8

		font.pixelSize: 15
		font.bold: true

		color: "#de000000"
		text: "Game Title"
	}

	Text {
		id: textSubtitle

		anchors.top: textTitle.bottom
		anchors.topMargin: 8
		anchors.left: imageIcon.right
		anchors.leftMargin: 10

		font.pixelSize: 10
		text: "Author"
	}

	Text {
		id: textInformation

		anchors.right: buttonAction.left
		anchors.rightMargin: 8
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8

		font.pixelSize: 10
		text: "INFO"
	}

	ActionButton {
		id: buttonAction
		z: 2

		anchors.top: parent.top
		anchors.topMargin: 8
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 8

		text: "Info"
		onClicked: {

			switch(currentStatus) {
				case Code.DEFINES.productDownload:

					break;
			}
		}
	}


	/* Signal */
	onClicked: {
		var d = humbleUser.getItemDownloads(dbIdent, "ebook")

		if ( d.length === 1) {
			//
			Code.downloadProduct(d[0].url, "ebook", d[0].product_id, d[0].machine_name)
		} else if ( d.length > 1) {
			// TODO: Open  chooser
			console.log('Too many download for ', dbIdent)
		} else {
			// TODO: Show Alert
			console.log('No download for ', dbIdent)
		}
	}

	/* On QML Load */

	/* Function */
	function openDialog()
	{
		/*
		Code.qmlComponent("game/GameDialog.qml", pageMainWindow, {
							  'productIdent': dbIdent,
							  'productIcon': dbIcon,
							  'productTitle': dbProduct,
							  'productOrder': dbOrder
						  })
						  */
	}




}
