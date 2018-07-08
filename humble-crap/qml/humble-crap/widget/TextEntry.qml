import QtQuick 2.0

Rectangle {
	property alias echoMode: input.echoMode
	property alias text: input.text
	property alias placeholder: placeholder.text
	width: 200
	height: 22
	border.width: 1
	border.color: "#000000"

	TextInput {
		id: input
		color: "#8a000000"
		text: ""
		antialiasing: true
		clip: true
		renderType: Text.QtRendering
		anchors.rightMargin: 4
		anchors.leftMargin: 4
		anchors.bottomMargin: 4
		anchors.topMargin: 4
		anchors.fill: parent
		transformOrigin: Item.Left
		horizontalAlignment: Text.AlignLeft

		selectByMouse: true
		selectionColor: "#607d8a"
		Text {
			id: placeholder

			color: "#aaa"
			elide: Text.ElideMiddle
			clip: true
			visible: !input.text
		}
	}
	states: [
		State {
			name: "error"

			PropertyChanges {
				target: rectangle
				color: "#d8b9b9"
				border.color: "#4d1616"
			}
		}
	]
	onFocusChanged: {
		if ( focus ) {
			input.forceActiveFocus(); //If rectangle is focus via keyNav, move to input instead
		}
	}
}
