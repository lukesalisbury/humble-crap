import QtQuick 2.0

Rectangle {
	id: pageMainWindow
    width: 400
    height: 400

    signal refresh

    ButtonBar {
        id: barFooter
        x: 0
        y: 300
        width: parent.width
        height: 54
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        z: 1
    }

    Rectangle {
        id: boxTitle
        x: 200
        y: 348
        width: parent.width ? parent.width : 400
        height: 64
        color: "#131f8f"
        anchors.leftMargin: 0
        opacity: 1
        anchors.right: parent.right
        anchors.topMargin: 0
        visible: true
        anchors.left: parent.left
        anchors.rightMargin: 0
        Text {
            id: textTitle
            y: 0
            width: 360
            height: 29
            color: "#ffffff"
            text: qsTr("Humble Crap")
            anchors.leftMargin: 0
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.rightMargin: 0
            font.pointSize: 18
        }

        Text {
            id: textSubTitle
            x: 0
            y: 29
            width: 360
            height: 14
            color: "#ffffff"
            text: qsTr("Content Retrieving Application")
            anchors.leftMargin: 0
            horizontalAlignment: Text.AlignHCenter
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.rightMargin: 0
            font.pixelSize: 12
        }

        Row {
            id: menurow
            x: 72
            width: 241
            height: 16
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            CategoryButton {
                id: categoryWindows
                name: "Windows"
            }

            CategoryButton {
                id: categoryLinux
                name: "Linux"
            }

            CategoryButton {
                id: categoryOSX
                name: "OS X"
            }

            CategoryButton {
                id: categoryAudio
                name: "Audio"
            }

            CategoryButton {
                id: categoryEbook
                name: "ebook"
            }
            anchors.bottomMargin: 0
            spacing: 2
        }
        z: 1
        anchors.top: parent.top
    }

    onRefresh: {
        var downloaded = downloadHumble.getContent()
        xmlModel.setXML(downloaded)
    }

	Component.onCompleted: {
		//Qt.createComponent("StartUpDialog.qml").createObject(pageMainWindow, {});

	}

    Connections {
        target: downloadHumble

		onRefresh:{
			var downloaded = downloadHumble.getContent()
			xmlModel.setXML(downloaded)
		}

        onDownloaded: {
			xmlModel.startTorrent(id, file)


        }

		onDownloadError: {}
		//onAppError: {}
		//onAppSuccess: {}

    }

    Connections {
        target: categoryWindows
        onClicked: {
            list.state = "windows"
        }
    }

    Connections {
        target: categoryLinux
        onClicked: {
            list.state = "linux"
        }
    }

    Connections {
        target: categoryEbook
        onClicked: {
            list.state = "ebook"
        }
    }

    Connections {
        target: categoryAudio
        onClicked: {
            list.state = "audio"
        }
    }

    Connections {
        target: categoryOSX
        onClicked: {
            list.state = "osx"
        }
    }

    ListView {
        id: list
        snapMode: ListView.SnapToItem
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: barFooter.top
        anchors.bottomMargin: 0
        anchors.top: boxTitle.bottom
        anchors.topMargin: 0

        boundsBehavior: Flickable.StopAtBounds

        model: xmlModel
        delegate: GameListItem {
            title: itemTitle
            subtitle: itemSubtitle
            icon: itemIcon
            listid: itemID
            state: list.state
            Component.onCompleted: {

                set({
                        linux: linuxDL,
                        windows: windowsDL,
                        osx: osxDL,
                        audio: audioDL,
                        ebook: ebookDL
                    }, {
                        linux: linuxDate,
                        windows: windowsDate,
                        osx: windowsDate
                    })
            }
        }
    }

    HumbleItemList {
        id: xmlModel
        function setXML(downloaded) {

            var startIndex = downloaded.indexOf(
                        "<div id='regular_download_list'")
            var endIndex = downloaded.indexOf(
                        "    </div>\n  </div>\n</div>\n\n<div id='confirm-apk' class='download-popup' style='display:none'>")
            downloaded = downloaded.substring(startIndex, endIndex)

            downloaded = downloaded.replace(
                        /<div class=\'[A-Za-z0-9 =_]*?\'><\/div>/g, "")
            downloaded = downloaded.replace(/&t/g, "&amp;t")
            downloaded = downloaded.replace(/\n{2,}/g, "\n")
            downloaded = downloaded.replace(/\n {1,}\n/g, "\n")
            downloaded = downloaded.replace(/<input([A-Za-z0-9 \'=_]*?)>/g, "")
            downloaded = downloaded.replace(/<a class=\'a\'\s+ download/g,
                                            "<a class='a'")

			downloadHumble.saveFile(downloaded, "humble.xml")
            xmlModel.xml = downloaded
            //xmlModel.reload()
        }
    }
}
