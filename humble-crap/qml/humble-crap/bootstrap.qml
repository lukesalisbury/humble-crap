import QtQuick 2.11
import QtQuick.Window 2.3

Window {
	flags: Qt.SplashScreen
	visible: false
	Component.onCompleted: {
		var comp = Qt.createComponent("InitWindow.qml")
		if (comp.status === Component.Ready) {
			comp.createObject()
		}
	}
}
