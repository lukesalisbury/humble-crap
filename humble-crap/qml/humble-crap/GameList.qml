import QtQuick 2.0

ListView {
	snapMode: ListView.SnapToItem
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
	Component.onCompleted: {
		console.log( parent )
	}
}
