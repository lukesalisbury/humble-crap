import QtQuick 2.11
import "../scripts/ProsaicDefine.js" as Prosaic


Rectangle {
	id: rectangle
	width: parent.width
	height: 48
	color: "#333333"
	radius: 1
	border.width: 0

	anchors.right: parent.right
	anchors.left: parent.left

	property int totalBytes: total
	property int downloadedBytes: downloaded
	property int ident: id
	property int downloadStatus: downloadstate
	property bool active: true

	signal successful(string content)
	signal error(string message)

	Text {
		id: textMessage
		color: "#ffffff"
		text: filename
		verticalAlignment: Text.AlignVCenter
		anchors.right: buttonState.left
		anchors.rightMargin: 8
		wrapMode: Text.WrapAnywhere
		anchors.left: parent.left
		anchors.leftMargin: 24
		anchors.top: parent.top
		anchors.topMargin: 8
		font.pointSize: 8
	}
	Text {
		color: "#868686"
        text:  bytesToHumanReadable(downloadedBytes) + " of " + bytesToHumanReadable(totalBytes) + ' - ' + url
		elide: Text.ElideMiddle
		anchors.right: buttonState.left
		anchors.rightMargin: 8
		anchors.left: parent.left
		anchors.leftMargin: 24
		anchors.top: textMessage.bottom
		anchors.topMargin: 0
	}
	ActionButton {
		id: buttonState
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: parent.right
		anchors.rightMargin: 8
		text: stateName(downloadStatus)
		onClicked: {
			if ( active ) {
				if ( downloadStatus == Prosaic.DIS.INACTIVE) {
					//downloadStatus = Prosaic.DIS.UNKNOWN
					active = false
					humbleDownloadQueue.changeDownloadItemState(ident, Prosaic.DIS.ACTIVE )
				} else if ( downloadStatus == Prosaic.DIS.ACTIVE) {
					//downloadStatus = Prosaic.DIS.UNKNOWN
					active = false
					humbleDownloadQueue.changeDownloadItemState(ident, Prosaic.DIS.INACTIVE )
				}
			}
		}
	}

	Rectangle {
		id: progressRectangle
		width: totalBytes > 0 ? (rectangle.width * (downloadedBytes / totalBytes)) : 0
		height: 4
		color: "#3b7e40"
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0
	}

	ActionButton {
		id: actionButton
		x: 176
		y: 16
		width: 16
		text: "f"
		anchors.verticalCenter: parent.verticalCenter
		anchors.right: buttonState.left
		anchors.rightMargin: 0
		onClicked: {
			humbleDownloadQueue.openDirectory(ident)
		}
	}

	onTotalBytesChanged: {
		progressRectangle.width = totalBytes
				> 0 ? (rectangle.width * (downloadedBytes / totalBytes)) : 5
	}

	onDownloadedBytesChanged: {
		progressRectangle.width = totalBytes
				> 0 ? (rectangle.width * (downloadedBytes / totalBytes)) : 5
	}
	onDownloadStatusChanged: {
		buttonState.text = stateName(downloadStatus)
		active = true
	}

	function bytesToHumanReadable(bytes) {
		if ( bytes > 10737418240) {
			return Math.floor(bytes/1073741824) + 'GB';
		} else if ( bytes > 10485760) {
			return Math.floor(bytes/1048576) + 'MB';
		} else if ( bytes > 10000 ) {
			return Math.floor(bytes/1024) + 'KB';
		} else {
			return bytes + 'B';
		}
	}

	function stateName(downloadState) {
		switch ( downloadState ) {
			case 1:
				return "Pause"
			case 2:
				return "Done"
			case -1:
				return "..."
			default:
				return "Resume"
		}

	}
}
