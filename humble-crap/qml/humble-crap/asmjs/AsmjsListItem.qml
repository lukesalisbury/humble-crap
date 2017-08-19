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
import Crap.Humble.Package 1.0

import "../widget"
import "../scripts/GameDatabase.js" as GameDatabase

Item {
	height: 62
	width: 400
	visible: true

	signal updateStatus

	property int dbStatus: 0
	property string dbIdent: ""
	property alias dbProduct: textTitle.text
	property alias dbAuthor: textSubtitle.text
	property alias dbIcon: imageIcon.source
	property string dbFormat: "x"
	property string dbReleaseDate: "0"
	property string dbInstalledDate: "0"
	property string dbLocation: ""
	property string dbExecutable: ""

	property alias buttonBackground: buttonAction.background
	property alias buttonColor: buttonAction.text

	property date releaseDate: new Date()
	property date installedDate: new Date()
	property variant database_info
	property bool hasUpdate: false
	property bool canPlay: false


	onUpdateStatus: {
		database_info = GameDatabase.getInfo(dbIdent, dbFormat, pageMainWindow.page)
	}


	MouseArea {
		property string ident: parent.dbIdent
		property string format: parent.dbFormat
		id: mouseArea
		anchors.fill: parent

		Image {
			id: imageIcon
			x: 16
			y: 16
			width: 32
			anchors.left: parent.left
			anchors.leftMargin: 16
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 16
			anchors.top: parent.top
			anchors.topMargin: 16
			sourceSize.height: 32
			sourceSize.width: 32
			fillMode: Image.PreserveAspectFit
			source: "humble-crap64.png"
		}

		Text {
			id: textTitle
			x: 58
			y: 11
			font.bold: true
			anchors.left: imageIcon.right
			anchors.leftMargin: 10
			font.pixelSize: 15
			color: "#de000000"
		}

		Text {
			id: textSubtitle
			x: 58
			y: 37
			anchors.left: imageIcon.right
			anchors.leftMargin: 10
			font.pixelSize: 10
		}

		Text {
			id: textInformation
			x: 324
			y: 37
			visible: true

			horizontalAlignment: Text.AlignRight
			anchors.right: buttonAction.left
			anchors.rightMargin: 8
			font.pixelSize: 10
			text: ""

		}

		ActionButton {
			id: buttonAction
			x: 332
			y: 8
			z: 2
			anchors.top: parent.top
			anchors.topMargin: 8
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 8
			anchors.right: parent.right
			anchors.rightMargin: 4
			text: "Info"
			onClicked: {
				database_info = GameDatabase.getInfo(parent.ident, parent.format, pageMainWindow.page)
				Qt.createComponent("AsmjsDialog.qml").createObject( pageMainWindow, { info: database_info, item: parent.parent })
			}
		}
		onClicked: {
			database_info = GameDatabase.getInfo(ident, format, pageMainWindow.page)
			Qt.createComponent("AsmjsDialog.qml").createObject( pageMainWindow, { info: database_info, item: parent })
		}
	}

	Component.onCompleted: {

	}
}
