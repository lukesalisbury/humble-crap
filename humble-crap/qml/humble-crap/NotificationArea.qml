import QtQuick 2.0

Item {
	id: item1
	width: 100
	height: 65
	z: 10

	property int xaxis: 0


	function addNotication(widget, attributes, success ) {
		var note;

		var component = Qt.createComponent(widget)
		if (component.status == Component.Ready) {
			attributes.anchors = {
				centerIn: parent
			}
			note = component.createObject(column1, attributes)
			if ( success )
				note.successful.connect(success);
		}

		return note;
	}


	Column {
		id: column1
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0
		anchors.right: parent.right
		anchors.rightMargin: 0
		transformOrigin: Item.BottomRight
		anchors.horizontalCenter: parent.horizontalCenter
		spacing: 4

	}
}
