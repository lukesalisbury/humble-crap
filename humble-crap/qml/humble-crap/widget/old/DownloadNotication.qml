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
import Crap.Humble.Download 1.0

Rectangle {
	id: download_rectangle
	width: 288
	height: 48
	color: "#333333"
	radius: 1
	border.width: 0
	opacity: 1
	property alias url: downloader.url
	property alias progress: downloader.progress
	property bool textMode: true
	property url cacheFile: ""

	signal successful( string content )
	signal error( string message )

	Text {
        id: textMessage
		color: "#ffffff"
		text: qsTr("Text")
		verticalAlignment: Text.AlignVCenter
		anchors.right: status.left
		anchors.rightMargin: 0
		wrapMode: Text.WrapAnywhere
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 18
		anchors.left: parent.left
		anchors.leftMargin: 24
		anchors.top: parent.top
		anchors.topMargin: 18
		font.pointSize: 8
	}


	HumbleDownload {
		id: downloader
		onUrlChanged: {
            textMessage.text = "Downloading " + getUrlFile()
			makeRequest()
		}
		onAppError: {
			download_rectangle.error( getError() );
			download_rectangle.state = "Removing"
		}
		onAppSuccess: {
			if ( textMode ) {
				download_rectangle.successful( getContent() );
			} else {
				download_rectangle.successful( url.toString() );
				writeContent(cacheFile)
			}
			download_rectangle.state = "Removing"
		}
		onDownloadStarted: {

		}
        onRequestProgress: {
			meter.width = (status.width - 4) * progress
		}
	}

	states: [
		State {
			name: "Removing"
			PropertyChanges {
				target: download_rectangle
				opacity: 0
				height: 0
			}
		}
	]

	transitions: [
		Transition {
			from: "*"; to: "Removing"
			NumberAnimation { properties: "opacity"; easing.type: Easing.OutCurve; duration: 1000; onRunningChanged: {
					if (!running) {
						console.log("Destroying...")
					}
				} }
		}
	]
}
