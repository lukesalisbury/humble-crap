# Add more folders to ship with the application, here
folder_01.source = qml/humble-crap
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01


# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    packagehandling.cpp \
    humbleuser.cpp \
    humblenetwork.cpp \
    humblecrap.cpp \
    humbledownload.cpp \
    humblesystem.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
	qml/humble-qrap/Button.qml \
    qml/humble-crap/GameListItem.qml \
    qml/humble-crap/main.qml \
    qml/humble-crap/LoginDialog.qml \
    qml/humble-crap/CategoryButton.qml \
    qml/humble-crap/ItemDialog.qml

HEADERS += \
    packagehandling.hpp \
    humbleuser.hpp \
    humblenetwork.hpp \
    humblecrap.hpp \
    humbledownload.hpp \
    humblesystem.hpp


Qt += network widgets
LIBS += -lz
