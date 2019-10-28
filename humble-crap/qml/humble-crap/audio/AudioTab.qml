import QtQuick 2.11

ListView {
	snapMode: ListView.SnapToItem
	visible: true
	boundsBehavior: Flickable.StopAtBounds
	height: parent.height
	width: parent.width
	delegate: AudioListItem {
		dbProduct: product
		dbAuthor: author
		dbIdent: product_id
		//dbIcon: icon ? icon : "../images/humble-crap64.png"
		dbFormat: 'format'
		dbLocation: location ? location : ''
		dbExecutable: executable ? executable : ''
		dbInstalledDate: installed
		dbReleaseDate: '0'
		dbOrder: orderkey
		anchors.left: parent.left
		anchors.right: parent.right

	}
}
