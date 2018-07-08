import QtQuick 2.0
import QtQuick.Controls 1.1

import "../scripts/CrapDatabase.js" as CrapDatabase

Rectangle {
	property variant info
	property variant item
	id: pageItem
	color: "#60000000"
	opacity: 1
	z: 1
	x: 0
	y: 0
	width: 300
	height: 200
	anchors.fill: parent

	onItemChanged: {
		//'<iframe style="width: <%- width %>px; height: <%- (width * 0.5625) + 40 %>px; background: black" data-machine-name="<%- machineName %>" src="/play/<%- machineName %>/<%- auth %>?&auto_start=<%- autoStart %>&allow_auto_download=<%- allowAutoDownload %>" frameborder="0" allowfullscreen="allowfullscreen" sandbox="allow-scripts allow-same-origin allow-pointer-lock" scrolling="no"></iframe>\n'
		//webASM.loadHtml('', 'https://www.humblebundle.com/play/<%- machineName %>/<%- auth %>?&auto_start=1', '');

	}

	MouseArea {
		id: mousearea1
		hoverEnabled: true
		anchors.fill: parent
		propagateComposedEvents: false


	}
}

