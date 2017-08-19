import QtQuick 2.0

ListView {
	anchors.top: parent.top
	anchors.left: parent.left
	anchors.right: parent.right
	anchors.bottom: parent.bottom
	snapMode: ListView.SnapToItem
	visible: true
	boundsBehavior: Flickable.StopAtBounds

	delegate: AudioListItem {
		dbProduct: product
		dbAuthor: author
		dbIdent: ident
		dbIcon: icon ? icon : "humble-crap64.png"
		dbFormat: format
		dbLocation: location ? location : ' '
		anchors.left: parent.left
		anchors.right: parent.right
	}
}
