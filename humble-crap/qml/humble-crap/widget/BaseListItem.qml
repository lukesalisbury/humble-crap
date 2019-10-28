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
import "../scripts/CrapCode.js" as Code


Item {

	height: 62
	width: 400
	visible: true

	signal updateStatus
	signal clicked


	property int dbStatus: 0
	property string dbIdent: ""
	property string dbFormat: "x"
	property string dbReleaseDate: "0"
	property string dbInstalledDate: "0"
	property string dbLocation: ""
	property string dbExecutable: ""
	property string dbOrder: ""

	property date releaseDate: new Date()
	property date installedDate: new Date()
	property variant database_info
	property variant downloads_info
	property bool hasUpdate: false
	property bool canPlay: false
	property int currentStatus: Code.DEFINES.productSetup

	MouseArea {
		property string ident: parent.dbIdent
		property string format: parent.dbFormat

		id: mouseArea
		anchors.fill: parent

		/* MouseArea Signal */
		onClicked: {
			parent.clicked()
		}
	}
	/* Signal */
	onUpdateStatus: {
		database_info = humbleUser.getInfo(dbIdent)
		downloads_info = humbleUser.getDownloadInfo(dbIdent)
		dbInstalledDate = database_info['installed'] ? database_info['installed'] : ''
		dbExecutable = database_info['executable'] ? database_info['executable'] : ''
		dbLocation = database_info['location'] ? database_info['location'] : ''

		checkStatus();
	}

	onCurrentStatusChanged: {
		var i = currentStatus-Code.DEFINES.productSetup
		buttonBackground = Code.listItembuttonValues[i].colour
		buttonText = Code.listItembuttonValues[i].text
	}

	/* On QML Load */
	Component.onCompleted: {
		checkStatus()
	}

	/* Function */
	function checkStatus() {
		releaseDate = new Date(parseInt(dbReleaseDate) * 1000)
		installedDate = new Date(parseInt(dbInstalledDate) * 1000)

		currentStatus = Code.listItemCheckStatus(releaseDate, installedDate, dbExecutable)

	}

}
