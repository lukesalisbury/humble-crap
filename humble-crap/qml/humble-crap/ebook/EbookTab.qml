import QtQuick 2.0

ListView {
	snapMode: ListView.SnapToItem
	visible: true
	boundsBehavior: Flickable.StopAtBounds
	height: parent.height
	width: parent.width
	delegate: EbookListItem {
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
