
#include "qtquick2applicationviewer.h"
#include "downloadhumble.hpp"
#include "packagehandling.hpp"

#include <QtGui/QGuiApplication>
#include <QQmlContext>
#include <QtQml/qqml.h>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQuickWindow>

// Humble Bundle Content Retrieving APplication
DownloadHumble t;


int main(int argc, char *argv[])
{
	qmlRegisterType<PackageHandling>( "HumbleCrap.PackageHandling", 1, 0, "PackageHandling");

	QQuickWindow * window;
	QGuiApplication app(argc, argv);
	QQmlEngine engine;
	QQmlComponent component(&engine, QUrl::fromLocalFile("qml/humble-crap/main.qml") );


	app.connect( &engine, SIGNAL(quit()), SLOT(quit()) );
	engine.rootContext()->setContextProperty("downloadHumble", &t);


	if (!component.isReady())
	{
		qWarning("%s", qPrintable(component.errorString()));
		return -1;
	}
	QObject * object = component.create();

	window = qobject_cast<QQuickWindow*>( object );
	window->show();

	return app.exec();

}


/*
	QtQuick2ApplicationViewer viewer;


	viewer.rootContext()->setContextProperty("downloadHumble", &t);

	viewer.setTitle("Humble Crap");
	viewer.setMainQmlFile(QStringLiteral("qml/humble-crap/main.qml"));
	viewer.showExpanded();
*/
