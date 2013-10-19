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

		}
	}

 Rectangle {
	 id: rectangle2
	 x: 71
	 y: 37
	 width: 159
	 height: 22
	 color: "#ffffff"

	 TextInput {
		 id: inputUser
		 text: downloadHumble.getUsername()
   anchors.fill: parent
		 font.pixelSize: 12
	 }
 }

 Rectangle {
	 id: rectangle3
	 x: 71
	 y: 72
	 width: 159
	 height: 23
	 color: "#ffffff"

	 TextInput {
		 id: inputPassword
		 text: downloadHumble.getPassword()
   anchors.fill: parent
		 echoMode: TextInput.Password
		 font.pixelSize: 12
	 }
 }

 Text {
	 id: text1
	 x: 37
	 y: 40
	 text: qsTr("Email:")
	 font.bold: true
	 horizontalAlignment: Text.AlignRight
	 font.pixelSize: 12
 }

 Text {
	 id: text2
	 x: 14
	 y: 75
	 text: qsTr("Password")
	 font.bold: true
	 horizontalAlignment: Text.AlignRight
	 font.pixelSize: 12
 }
}
