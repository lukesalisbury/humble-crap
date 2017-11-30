import QtQuick 2.0
import "../widget"
Item {
    id: item1
    width: 200
    height: 64


    DialogButton {
        id: submitGuardButton;
        text: "Submit"
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
    }
    Rectangle {
        id: rectanglePin
        x: 92
        width: 64
        height: 22
        color: "#00000000"
        anchors.topMargin: 16
        TextInput {
            id: inputPin
            width: 100
            color: "#8a000000"
            text: ""
            anchors.topMargin: 2
            anchors.fill: parent
            transformOrigin: Item.Left
            horizontalAlignment: Text.AlignLeft
            anchors.rightMargin: 2
            selectionColor: "#607d8a"
            anchors.bottomMargin: 2
            clip: false
            anchors.leftMargin: 2
            Keys.onReturnPressed: {
                buttonLogon.clicked()
            }
        }
        anchors.rightMargin: 24
        border.color: "#000000"
        anchors.top: rectanglePassword.bottom
        anchors.right: parent.right
    }

    Text {
        id: textPin
        y: 177
        text: qsTr("Security Code")
        horizontalAlignment: Text.AlignRight
        anchors.verticalCenter: rectanglePin.verticalCenter
        anchors.right: rectanglePin.left
        anchors.rightMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 24
        font.bold: true
    }
}
