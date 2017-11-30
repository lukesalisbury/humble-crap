
# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    humble-crap.cpp \
    humble-download.cpp \
    humble-network.cpp \
    humble-system.cpp \
    humble-user.cpp \
    package-handling.cpp \
    humble-file.cpp \
    local-cookie-jar.cpp


HEADERS += \
    global.hpp \
    humble-crap.hpp \
    humble-download.hpp \
    humble-network.hpp \
    humble-system.hpp \
    humble-user.hpp \
    package-handling.hpp \
    humble-file.hpp \
    local-cookie-jar.hpp


QT += network widgets qml quick core
LIBS += -lz

RESOURCES +=

RC_ICONS = humble-crap80.ico

QMAKE_CXXFLAGS += -std=c++11


DISTFILES += \
    qml/humble-crap/widget/ActionButton.qml \
    qml/humble-crap/widget/BackgroundDownloadNotication.qml \
    qml/humble-crap/widget/ButtonBar.qml \
    qml/humble-crap/widget/CategoryButton.qml \
    qml/humble-crap/widget/DatabaseListModel.qml \
    qml/humble-crap/widget/DatabaseParseList.qml \
    qml/humble-crap/widget/DialogButton.qml \
    qml/humble-crap/widget/DownloadNotication.qml \
    qml/humble-crap/widget/NotificationArea.qml \
    qml/humble-crap/widget/PackageSelector.qml \
    qml/humble-crap/widget/ParseNotication.qml \
    qml/humble-crap/widget/SimpleDownloadNotication.qml \
    qml/humble-crap/scripts/GameDatabase.js \
    qml/humble-crap/images/humble-crap64.png \
    qml/humble-crap/asmjs/AsmjsDialog.qml \
    qml/humble-crap/asmjs/AsmjsListItem.qml \
    qml/humble-crap/asmjs/AsmjsTab.qml \
    qml/humble-crap/audio/AudioListItem.qml \
    qml/humble-crap/audio/AudioTab.qml \
    qml/humble-crap/dialog/LoginDialog.qml \
    qml/humble-crap/dialog/SettingDialog.qml \
    qml/humble-crap/ebook/EbookListItem.qml \
    qml/humble-crap/ebook/EbookTab.qml \
    qml/humble-crap/game/GameListItem.qml \
    qml/humble-crap/game/GameTab.qml \
    qml/humble-crap/game/ItemDialog.qml \
    qml/humble-crap/main.qml \
    qml/humble-crap/dialog/MainDialog.qml \
    qml/humble-crap/dialog/ErrorDialog.qml \
    qml/humble-crap/style/SimpleTheme.js \
    qml/humble-crap/scripts/FontAwesome.js \
    qml/humble-crap/widget/IconButton.qml \
    qml/humble-crap/font/fontawesome-webfont.ttf \
    qml/humble-crap/dialog/MainWindow.qml \
    qml/humble-crap/widget/FileChooserWidget.qml \
    qml/humble-crap/dialog/FileChooserDialog.qml \
    qml/humble-crap/scripts/ProductsWorker.js \
    qml/humble-crap/scripts/OrdersWorker.js \
    qml/humble-crap/dialog/ItemDialog.qml \
    qml/humble-crap/dialog/WebDialog.qml \
    qml/humble-crap/game/GameDialog.qml \
    qml/humble-crap/dialog/CaptchaDialog.qml \
    qml/humble-crap/dialog/GuardDialog.qml

