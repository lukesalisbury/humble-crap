/****************************************************************************
* Copyright (c) 2015 Luke Salisbury
*
* This software is provided 'as-is', without any express or implied
* warranty. In no event will the authors be held liable for any damages
* arising from the use of this software.
*
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
*
* 1. The origin of this software must not be misrepresented; you must not
*    claim that you wrote the original software. If you use this software
*    in a product, an acknowledgement in the product documentation would be
*    appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
*    misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
****************************************************************************/

#include "humble-crap.hpp"
#include "package-handling.hpp"
#include "humble-user.hpp"
#include "humble-download.hpp"
#include "humble-system.hpp"

#include <QtGui/QGuiApplication>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlComponent>
#include <QtQuick/QQuickWindow>


// Humble Bundle Content Retrieving APplication
QNetworkAccessManager webManager;
HumbleCrap * humble_core;
HumbleUser * humble_user;
HumbleSystem * humble_system;

QNetworkAccessManager * getNetworkManager()
{
	return &webManager;
}

int main(int argc, char *argv[])
{
	qmlRegisterType<PackageHandling>( "Crap.Humble.Package", 1, 0, "HumblePackage");
	qmlRegisterType<HumbleDownload>( "Crap.Humble.Download", 1, 0, "HumbleDownload");
	qmlRegisterType<HumbleSystem>( "Crap.Humble.System", 1, 0, "HumbleSystem");


	QQuickWindow * window;
	QGuiApplication app(argc, argv);
	QQmlEngine engine;
	QQmlComponent component(&engine, QUrl("../humble-crap/qml/humble-crap/dialog/MainWindow.qml") );
	QObject * object;

	humble_core = new HumbleCrap();
	humble_user = new HumbleUser();
	humble_system = new HumbleSystem();

	app.connect( &engine, SIGNAL(quit()), SLOT(quit()) );

	engine.rootContext()->setContextProperty("humbleCrap", humble_core);
	engine.rootContext()->setContextProperty("humbleUser", humble_user);
	engine.rootContext()->setContextProperty("humbleSystem", humble_system);

    humble_user->setUser("dummy");

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

