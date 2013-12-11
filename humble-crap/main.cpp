#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include "downloadhumble.hpp"
#include <QQmlContext>

// Humble Bundle Content Retrieving APplication

int main(int argc, char *argv[])
{


	DownloadHumble t;


	QGuiApplication app(argc, argv);



	QtQuick2ApplicationViewer viewer;


	viewer.rootContext()->setContextProperty("downloadHumble", &t);
    viewer.setTitle("Humble Crap");
    viewer.setMainQmlFile(QStringLiteral("qml/humble-crap/MainWindow.qml"));
	viewer.showExpanded();





	return app.exec();
}
