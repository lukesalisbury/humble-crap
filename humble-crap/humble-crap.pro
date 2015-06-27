
# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    packagehandling.cpp \
    humbleuser.cpp \
    humblenetwork.cpp \
    humblecrap.cpp \
    humbledownload.cpp \
    humblesystem.cpp


HEADERS += \
    packagehandling.hpp \
    humbleuser.hpp \
    humblenetwork.hpp \
    humblecrap.hpp \
    humbledownload.hpp \
    humblesystem.hpp \
    global.hpp


QT += network widgets qml quick core
LIBS += -lz

RESOURCES +=

QMAKE_CXXFLAGS += -std=c++11


DISTFILES += \
    qml/humble-crap/GameDatabase.js \
    qml/humble-crap/ActionButton.qml \
    qml/humble-crap/ButtonBar.qml \
    qml/humble-crap/DialogButton.qml \
    qml/humble-crap/DownloadNotication.qml \
    qml/humble-crap/FileChooserButton.qml \
    qml/humble-crap/FileDialog.qml \
    qml/humble-crap/NotificationArea.qml \
    qml/humble-crap/PackageSelector.qml \
    qml/humble-crap/ParseNotication.qml \
	qml/humble-qrap/Button.qml \
	qml/humble-crap/GameListItem.qml \
	qml/humble-crap/main.qml \
	qml/humble-crap/LoginDialog.qml \
	qml/humble-crap/CategoryButton.qml \
	qml/humble-crap/ItemDialog.qml \
    qml/humble-crap/DatabaseListModel.qml \
    qml/humble-crap/GameOrdersWorker.js \
    qml/humble-crap/BackgroundDownloadNotication.qml \
    qml/humble-crap/SimpleDownloadNotication.qml \
    qml/humble-crap/OrderParseNotication.qml \
    qml/humble-crap/UpdateListWorker.js
