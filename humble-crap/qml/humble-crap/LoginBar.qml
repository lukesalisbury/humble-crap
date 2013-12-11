import QtQuick 2.0

Rectangle {
    id: rectangle1
    width: 300
    height: 200
    color: "#6d1d1d"
    Button {
        id: buttonLogon
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
        KeyNavigation.tab: inputUser
        onClicked: {
            mainPage.state = ' '
            downloadHumble.go(inputUser.text, inputPassword.text)
        }
    }

    Rectangle {
        id: rectangle2
        x: 100
        y: 36
        width: 159
        height: 22
        color: "#ffffff"

        TextInput {
            id: inputUser
            text: downloadHumble.getUsername()
            clip: false
            anchors.fill: parent
            font.pixelSize: 12
            KeyNavigation.tab: inputPassword
        }
    }

    Rectangle {
        id: rectangle3
        x: 100
        y: 71
        width: 159
        height: 23
        color: "#ffffff"

        TextInput {
            id: inputPassword
            text: downloadHumble.getPassword()
            anchors.fill: parent
            echoMode: TextInput.Password
            font.pixelSize: 12
            KeyNavigation.tab: buttonLogon
        }
    }

    Text {
        id: text1
        x: 56
        y: 40
        text: qsTr("Email:")
        font.bold: true
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 12
    }

    Text {
        id: text2
        x: 36
        y: 76
        text: qsTr("Password")
        font.bold: true
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 12
    }
}
