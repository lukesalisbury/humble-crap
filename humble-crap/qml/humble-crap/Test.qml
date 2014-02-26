import QtQuick 2.0
import QtQuick.Controls 1.1

ApplicationWindow {
	visible: true
	width: 360
	height: 360
	title: "MyWindow"

	Text {
		text: "Hello world!"
		anchors.centerIn: parent
	}

	onClosing: Qt.quit()
}
