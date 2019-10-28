import QtQuick 2.11
import "asmjs"
import "audio"
import "dialog"
import "ebook"
import "game"
import "widget"

Item {
	id: item1
	height: 36
	width: 200
	Text {
		text: 'File:' + platform + ' Version: ' + version
		elide: Text.ElideMiddle
		font.bold: true

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.right: buttonAction.left
		anchors.rightMargin: 8
	}

	ActionButton {
		id: buttonAction
		text: format
		anchors.verticalCenter: parent.verticalCenter

		anchors.right: parent.right
		anchors.rightMargin: 8
	}
}
