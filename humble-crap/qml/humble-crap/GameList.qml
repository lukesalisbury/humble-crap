import QtQuick 2.0

ListView {
	snapMode: ListView.SnapToItem
	anchors.right: parent.right
	anchors.rightMargin: 0
	anchors.left: parent.left
	anchors.leftMargin: 0
	anchors.bottom: parent.top
	anchors.bottomMargin: 0
	anchors.top: parent.bottom
	anchors.topMargin: 0
	visible: true
	boundsBehavior: Flickable.StopAtBounds


	delegate: GameListItem {
		title: itemTitle
		subtitle: itemSubtitle
		icon: itemIcon
		listid: itemID
		Component.onCompleted: {
			set({
					linux: linuxDL,
					windows: windowsDL,
					osx: osxDL,
					audio: audioDL,
					ebook: ebookDL
				}, {
					linux: linuxDate,
					windows: windowsDate,
					osx: windowsDate
				})
		}
	}
}
