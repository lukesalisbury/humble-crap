
#include "qtquick2applicationviewer.h"
#include "humblecrap.hpp"
#include "packagehandling.hpp"
#include "humbleuser.hpp"
#include "humbledownload.hpp"

#include <QtGui/QGuiApplication>
#include <QQmlContext>
#include <QtQml/qqml.h>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQuickWindow>

// Humble Bundle Content Retrieving APplication
QNetworkAccessManager webManager;
HumbleCrap * t;
HumbleUser * user;


QNetworkAccessManager * getNetworkManager()
{
	return &webManager;
}

int main(int argc, char *argv[])
{
	qmlRegisterType<PackageHandling>( "Crap.Humble.Package", 1, 0, "HumblePackage");
	qmlRegisterType<HumbleDownload>( "Crap.Humble.Download", 1, 0, "HumbleDownload");


	QQuickWindow * window;
	QGuiApplication app(argc, argv);
	QQmlEngine engine;
	QQmlComponent component(&engine, QUrl::fromLocalFile("qml/humble-crap/main.qml") );
	QObject * object;

	t = new HumbleCrap();
	user = new HumbleUser();

	app.connect( &engine, SIGNAL(quit()), SLOT(quit()) );

	engine.rootContext()->setContextProperty("humbleCrap", t);
	engine.rootContext()->setContextProperty("humbleUser", user);

	if (!component.isReady())
	{
		qWarning("%s", qPrintable(component.errorString()));
		return -1;
	}

	object = component.create();
	window = qobject_cast<QQuickWindow*>( object );
	window->show();

	return app.exec();

}

