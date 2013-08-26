#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include "downloadhumble.hpp"
#include <QQmlContext>

// Qt-based Retrieving APplication

int main(int argc, char *argv[])
{
	DownloadHumble t;
	QGuiApplication app(argc, argv);

	QtQuick2ApplicationViewer viewer;
	viewer.rootContext()->setContextProperty("downloadHumble", &t);
	viewer.setMainQmlFile(QStringLiteral("qml/humble-crap/main.qml"));
	viewer.showExpanded();





	return app.exec();
}
