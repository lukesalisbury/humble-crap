import QtQuick 2.0

Rectangle {
	id: rectangle1
 width: 300
 height: 200
	color: "#6d1d1d"
	Button {
		id: button1
		x: 214
		y: 149
		width: 76
		height: 40
		text: "Login"
  anchors.bottom: parent.bottom
  anchors.bottomMargin: 11
		anchors.right: parent.right
		anchors.rightMargin: 10
		z: 1
		opacity: 1
		onClicked: {
			mainPage.state = ' '
			downloadHumble.go(inputUser.text, inputPassword.text)
			console.log(inputUser.text, inputPassword.text)

		}
	}

 TextInput {
	 id: inputUser
	 x: 110
	 y: 53
	 width: 80
	 height: 20
	 text: qsTr("Text")
  anchors.horizontalCenter: parent.horizontalCenter
	 font.pixelSize: 12
 }

 TextInput {
	 id: inputPassword
	 x: 110
	 y: 85
	 width: 80
	 height: 20
	 text: qsTr("Text")
  anchors.horizontalCenter: parent.horizontalCenter
	 echoMode: TextInput.Password
	 font.pixelSize: 12
 }
}
