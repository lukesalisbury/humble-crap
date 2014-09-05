import QtQuick 2.0

Rectangle {
	id: download_rectangle
	width: 288
	height: 48
	color: "#333333"
	radius: 1
	border.width: 0
	property string title: "Text"
	property int total: 0
	property int count: 0


	signal successful( string content )
	signal error( string message )



	Text {
		id: text
		color: "#ffffff"
		text: qsTr("Text")
		verticalAlignment: Text.AlignVCenter
		anchors.right: parent.right
		anchors.rightMargin: 24
		wrapMode: Text.WrapAnywhere
		font.family: "Verdana"
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 18
		anchors.left: parent.left
		anchors.leftMargin: 24
		anchors.top: parent.top
		anchors.topMargin: 18
		font.pointSize: 8
	}

	onTotalChanged:
	{
		text.text = title + " " +  count + "/" + total;
		if ( count === total )
			successful("completed")
	}

	onCountChanged:
	{
		text.text = title + " " +  count + "/" + total;
		if ( count === total )
		{
			successful("completed")
			state = "Removing"
		}
	}

	states: [
		State {
			name: "Removing"
			PropertyChanges {
				target: download_rectangle
				opacity: 0
			}
		}
	]

	transitions: [
		Transition {
			from: "*"; to: "Removing"
			NumberAnimation { properties: "opacity"; easing.type: Easing.OutCurve; duration: 1000; onRunningChanged: {
					if (!running) {
						console.log("Destroying...")
					}
				} }
		}
	]

}
