import QtQuick 2.0

Rectangle {
	color: "#104b9e"
	Button {
		id: buttonDownload
		width: 91
		text: qsTr("Download")
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 10
		anchors.top: parent.top
		anchors.topMargin: 10
		anchors.left: parent.left
		anchors.leftMargin: 10
		onClicked: {
			mainPage.state = 'logon'

			//downloadHumble.go()
		}
	}

	Button {
		id: buttonQuit
		x: 300
		onClicked: Qt.quit()
		text: qsTr("Quit")
		anchors.top: parent.top
		anchors.topMargin: 10
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 10
		anchors.right: parent.right
		anchors.rightMargin: 10
	}
}
