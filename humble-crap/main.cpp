/****************************************************************************
* Copyright © 2018 Luke Salisbury
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
#include "humble-system.hpp"
#include "prosaic-download-queue.hpp"

#include <QtGui/QGuiApplication>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlComponent>
#include <QtQuick/QQuickWindow>

// Humble Bundle Content Retrieving APplication
QNetworkAccessManager webManager;
HumbleCrap * humble_core;
HumbleUser * humble_user;
HumbleSystem * humble_system;
ProsaicDownloadQueue * humble_download;


QNetworkAccessManager * getNetworkManager()
{
	return &webManager;
}

QString getPathFromSettings(QString type)
{
	QString path = humble_core->getValue("path."+ type).toString();
	QDir dir;
	if ( dir.mkpath(path) )
		return path;
	return ""; // Return Empty String if path can not be created
}


int main(int argc, char *argv[])
{
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	QGuiApplication app(argc, argv);

	QQmlApplicationEngine engine;

	qmlRegisterType<PackageHandling>( "Crap.Humble.Package", 1, 0, "HumblePackage");
	//qmlRegisterType<HumbleSystem>( "Crap.Humble.System", 1, 0, "HumbleSystem");

	humble_core = new HumbleCrap();
	humble_user = new HumbleUser();
	humble_system = new HumbleSystem();
	humble_download = new ProsaicDownloadQueue();

	engine.rootContext()->setContextProperty("humbleCrap", humble_core);
	engine.rootContext()->setContextProperty("humbleUser", humble_user);
	engine.rootContext()->setContextProperty("humbleSystem", humble_system);
	engine.rootContext()->setContextProperty("humbleDownloadQueue", humble_download);

	engine.load("../humble-crap/qml/humble-crap/InitWindow.qml");

	if ( engine.rootObjects().isEmpty()) {
		return -1;
	}

	int retval = app.exec();

	delete humble_download;
	delete humble_system;
	delete humble_user;
	delete humble_core;

	return retval;

}

