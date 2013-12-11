import QtQuick 2.0

Rectangle {
    id: rectangle1
    property string name: "Windows"
	property string color: "#33aa2a"
    signal clicked
    width: 48
    height: 14
    radius: 3
    border.width: 1
    gradient: Gradient {

        GradientStop {
            id: gradientstop1
            position: 0
			color: rectangle1.color
        }

        GradientStop {
            id: gradientstop2
            position: 1
			color:  Qt.darker(rectangle1.color, 2.4)
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: rectangle1.clicked()
        onEntered: {
            parent.state = 'hover'
        }
        onExited: {
            parent.state = ' '
        }

        Text {
            id: text1
            color: "#ffffff"
            text: parent.parent.name
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            styleColor: "#0b0a0a"
            font.pixelSize: 8
        }
    }
    states: [
        State {
            name: "hover"

            PropertyChanges {
                target: gradientstop1
                position: 0
                color: "#33aa2a"
            }

            PropertyChanges {
                target: gradientstop2
                position: 1
                color: "#0b2509"
            }

            PropertyChanges {
                target: text1
                anchors.verticalCenterOffset: 1
            }
        }
    ]
    Transition {
        from: " "
        to: "hover"
        SequentialAnimation {
            NumberAnimation {
                target: gradientstop2
                easing.type: Easing.InQuad
                properties: "color"
                duration: 200
            }
        }
    }
}
