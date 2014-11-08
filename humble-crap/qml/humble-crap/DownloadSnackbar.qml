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
		id: text
		color: "#ffffff"
		text: qsTr("Text")
		verticalAlignment: Text.AlignVCenter
		anchors.right: status.left
		anchors.rightMargin: 0
		wrapMode: Text.WrapAnywhere
		font.family: "Verdana"
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 18
		anchors.left: parent.left
		anchors.leftMargin: 24
		anchors.top: parent.top
		anchors.topMargin: 18
		font.pointSize: 8
	}

	Rectangle {
		id: status
		x: 0
		width: 64
		color: "#dedede"
		anchors.top: parent.top
		anchors.topMargin: 8
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 24
		border.width: 0

		Rectangle {
			id: meter
			width: 0
			color: "Red"
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.left: parent.left

			anchors.topMargin: 2
			anchors.bottomMargin: 2
			anchors.leftMargin: 2
		}
	}

	HumbleDownload {
		id: downloader
		onUrlChanged: {
			text.text = "Downloading " + getUrlFile()
			makeRequest()
		}
		onAppError: {
			download_rectangle.error( getError() );
		}
		onAppSuccess: {
			if ( textMode) {
				download_rectangle.successful( getContent() );
			} else {
				download_rectangle.successful( url.toString() );
				writeContent(cacheFile)
			}
			download_rectangle.state = "Removing"
		}
		onDownloadStarted: {

		}
		onProgressUpdate: {
			meter.width = (status.width - 4) * progress
		}
	}

	states: [
		State {
			name: "Removing"
			PropertyChanges {
				target: download_rectangle
				opacity: 0
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
