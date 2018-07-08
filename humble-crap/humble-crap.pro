
# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    humble-crap.cpp \
    humble-network.cpp \
    humble-system.cpp \
    humble-user.cpp \
    package-handling.cpp \
    humble-file.cpp \
    local-cookie-jar.cpp \
    prosaic-download-queue.cpp \
    shared-functions.cpp


HEADERS += \
    global.hpp \
    humble-crap.hpp \
    humble-network.hpp \
    humble-system.hpp \
    humble-user.hpp \
    package-handling.hpp \
    humble-file.hpp \
    local-cookie-jar.hpp \
    miniz.h \
    prosaic-download-queue.hpp \
    shared-functions.hpp

TEMPLATE = app
QT += network widgets qml quick core
#QT += network widgets qml quick core webengine
LIBS = -lz

INCLUDEPATH += $$[QT_INSTALL_PREFIX]/src/3rdparty/zlib


RESOURCES +=

RC_ICONS = humble-crap80.ico

#QMAKE_CXXFLAGS += -std=c++11


DISTFILES += \
    qml/humble-crap/widget/ActionButton.qml \
    qml/humble-crap/widget/ButtonBar.qml \
    qml/humble-crap/widget/CategoryButton.qml \
    qml/humble-crap/widget/DatabaseListModel.qml \
    qml/humble-crap/widget/DatabaseParseList.qml \
    qml/humble-crap/widget/DialogButton.qml \
    qml/humble-crap/widget/DownloadNotication.qml \
    qml/humble-crap/widget/NotificationArea.qml \
    qml/humble-crap/widget/PackageSelector.qml \
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
    qml/humble-crap/dialog/MainDialog.qml \
    qml/humble-crap/dialog/ErrorDialog.qml \
    qml/humble-crap/style/SimpleTheme.js \
    qml/humble-crap/scripts/FontAwesome.js \
    qml/humble-crap/widget/IconButton.qml \
    qml/humble-crap/font/fontawesome-webfont.ttf \
    qml/humble-crap/widget/FileChooserWidget.qml \
    qml/humble-crap/dialog/FileChooserDialog.qml \
    qml/humble-crap/scripts/ProductsWorker.js \
    qml/humble-crap/dialog/ItemDialog.qml \
    qml/humble-crap/dialog/WebDialog.qml \
    qml/humble-crap/game/GameDialog.qml \
    qml/humble-crap/dialog/CaptchaDialog.qml \
    qml/humble-crap/dialog/GuardDialog.qml \
    qml/humble-crap/MainWindow.qml \
    qml/humble-crap/scripts/FontAwesome.js \
    qml/humble-crap/scripts/ProductsWorker.js \
    qml/humble-crap/font/FontAwesome.otf \
    qml/humble-crap/images/humble-crap64.png \
    qml/humble-crap/asmjs/AsmjsDialog.qml \
    qml/humble-crap/asmjs/AsmjsListItem.qml \
    qml/humble-crap/asmjs/AsmjsTab.qml \
    qml/humble-crap/audio/AudioListItem.qml \
    qml/humble-crap/audio/AudioTab.qml \
    qml/humble-crap/dialog/CaptchaDialog.qml \
    qml/humble-crap/dialog/ErrorDialog.qml \
    qml/humble-crap/dialog/FileChooserDialog.qml \
    qml/humble-crap/dialog/GuardDialog.qml \
    qml/humble-crap/dialog/ItemDialog.qml \
    qml/humble-crap/dialog/LoginDialog.qml \
    qml/humble-crap/dialog/MainDialog - Copy.qml \
    qml/humble-crap/dialog/MainDialog.qml \
    qml/humble-crap/dialog/SettingDialog.qml \
    qml/humble-crap/dialog/WebDialog.qml \
    qml/humble-crap/ebook/EbookListItem.qml \
    qml/humble-crap/ebook/EbookTab.qml \
    qml/humble-crap/game/GameDialog.qml \
    qml/humble-crap/game/GameListItem.qml \
    qml/humble-crap/game/GameTab.qml \
    qml/humble-crap/widget/ActionButton.qml \
    qml/humble-crap/widget/ButtonBar.qml \
    qml/humble-crap/widget/CategoryButton.qml \
    qml/humble-crap/widget/DatabaseListModel.qml \
    qml/humble-crap/widget/DatabaseParseList.qml \
    qml/humble-crap/widget/DialogButton.qml \
    qml/humble-crap/widget/DownloadNotication.qml \
    qml/humble-crap/widget/FileChooserWidget.qml \
    qml/humble-crap/widget/IconButton.qml \
    qml/humble-crap/widget/NotificationArea.qml \
    qml/humble-crap/widget/PackageSelector.qml \
    qml/humble-crap/MainWindow.qml \
    qml/humble-crap/scripts/FontAwesome.js \
    qml/humble-crap/scripts/ProductsWorker.js \
    qml/humble-crap/scripts/OrdersWorker.js \
    qml/humble-crap/widget/DownloadArea.qml \
    qml/humble-crap/font/sofiaprobold_1.otf \
    qml/humble-crap/font/sofiaproregular.otf \
    qml/humble-crap/InitWindow.qml \
    qml/humble-crap/InitWindow.qml \
    qml/humble-crap/dialog/InitDialog.qml \
    qml/humble-crap/widget/TextEntry.qml \
    qml/humble-crap/widget/TextEntry.qml \
    qml/humble-crap/scripts/UnwfStyle.js \
    qml/humble-crap/scripts/CrapDatabase.js \
    qml/humble-crap/scripts/CrapDatabase.js \
    qml/humble-crap/scripts/CrapCode.js \
    qml/humble-crap/trove/TroveListItem.qml \
    qml/humble-crap/trove/TroveTab.qml \
    qml/humble-crap/trove/TroveListItem.qml \
    qml/humble-crap/trove/TroveTab.qml \
    qml/humble-crap/widget/InlineNotication.qml \
    qml/humble-crap/widget/InlineNotication.qml \
    qml/humble-crap/dialog/CaptchaNoteDialog.qml \
    qml/humble-crap/dialog/DownloadsDialog.qml \
    qml/humble-crap/widget/DownloadListDelegate.qml \
    qml/humble-crap/scripts/ProsaicDefine.js \
    qml/humble-crap/scripts/ProsaicDownloadQueue.js \
    qml/humble-crap/scripts/CrapOrders.js \
    qml/humble-crap/Test.qml \
    qml/humble-crap/bootstrap.qml


