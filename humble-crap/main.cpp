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

#include "commandline-interface.hpp"
#include "global.hpp"
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlComponent>
#include <QtQuick/QQuickWindow>

// Humble Bundle Content Retrieving APplication
static QNetworkAccessManager webManager;
static HumbleCrap * humble_core = nullptr;
static HumbleUser * humble_user = nullptr;
static HumbleSystem * humble_system = nullptr;
static ProsaicDownloadQueue * humble_download = nullptr;
static PackageHandling * humble_package = nullptr;

/**
   @brief getNetworkManager
   @return
 */
QNetworkAccessManager * getNetworkManager() {
	return &webManager;
}

/**
   @brief getPathFromSettings
   @param type
   @return
 */
QString getPathFromSettings(QString type) {
	QString path = humble_core->getValue("path."+ type).toString();
	if ( !path.endsWith(QDir::separator()) && !path.endsWith("/") ) {
		path.append(QDir::separator());
	}

	QDir dir;
	if ( dir.mkpath(path) )
		return path;
	return ""; // Return Empty String if path can not be created
}

/**
   @brief getDirFromSettings
   @param type
   @return
 */
QDir getDirFromSettings(QString type)
{
	QString path = getPathFromSettings(type);
	QDir dir(path);

	if ( !dir.mkpath(path) )
		qWarning() << "Directory could not be created" << path;
	return dir;
}


int mainCLI(int argc, char *argv[]) {
	QCoreApplication app(argc, argv);
	CommandLineInterface program(&app);
	return app.exec();
}

int mainGUI(int argc, char *argv[]) {
	QGuiApplication app(argc, argv);
	QQmlApplicationEngine engine;

	//qmlRegisterType<PackageHandling>( "Crap.Humble.Package", 1, 0, "HumblePackage");
	//qmlRegisterType<HumbleSystem>( "Crap.Humble.System", 1, 0, "HumbleSystem");

	engine.rootContext()->setContextProperty("humbleCrap", humble_core);
	engine.rootContext()->setContextProperty("humbleUser", humble_user);
	engine.rootContext()->setContextProperty("humbleSystem", humble_system);
	engine.rootContext()->setContextProperty("humbleDownloadQueue", humble_download);
	engine.rootContext()->setContextProperty("packageHandling", humble_package);

	engine.load("../humble-crap/qml/humble-crap/InitWindow.qml");

	if ( engine.rootObjects().isEmpty()) {
		return -1;
	}
	return app.exec();
}

int main(int argc, char *argv[])
{
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
	QCoreApplication::setAttribute(Qt::AA_UseDesktopOpenGL);

	humble_core = new HumbleCrap();
	humble_user = new HumbleUser();
	humble_system = new HumbleSystem();
	humble_download = new ProsaicDownloadQueue();
	humble_package = new PackageHandling();

	humble_user->testMode = true;

	int retval = mainCLI(argc, argv);

	delete humble_download;
	delete humble_system;
	delete humble_user;
	delete humble_core;

	return retval;
}


/* Command Line Inferface */
CommandLineInterface::CommandLineInterface(QCoreApplication * a, QObject * parent) : QObject(parent) {
	this->app = a;

	connect(this, &CommandLineInterface::taskCompleted, this, &CommandLineInterface::exitSuccessfully);
	connect(this, &CommandLineInterface::taskFailed, this, &CommandLineInterface::exitWithFailure);

	QTimer::singleShot(0, this, &CommandLineInterface::mainTask);
}

CommandLineInterface::~CommandLineInterface() {
	qDebug() << "~CommandLineInterface";
}

void CommandLineInterface::mainTask() {
	QString user  = humble_core->getUsername();

	if ( user.size() ) {
		connect(humble_user, &HumbleUser::orderSuccess, this, &CommandLineInterface::orderSuccess);
		connect(humble_user, &HumbleUser::orderError, this, &CommandLineInterface::orderFailure);

		connect(humble_download, &ProsaicDownloadQueue::completed, this, &CommandLineInterface::downloadTaskSuccess);
		connect(humble_download, &ProsaicDownloadQueue::error, this, &CommandLineInterface::downloadTaskFailure);

		humble_user->setUser(user);
	}
}

void CommandLineInterface::downloadOrder(QString key) {
	if ( humble_user->testMode ) {
		QString path = getPathFromSettings("cache");
		QString filepath = QDir(path).filePath(key);
		QFile file(filepath);
		if ( file.open(QIODevice::ReadOnly | QIODevice::Text) ) {
			emit taskSuccess(key, file.readAll() );
			file.close();
		} else {
			emit taskFailure(key, "");
		}
	} else {
		humble_download->append(HUMBLEURL_ORDER + key, "cache", key, "",true, DIS_ACTIVE);
	}
}

void CommandLineInterface::orderSuccess() {
	QJsonDocument orderskeys = humble_user->getOrdersJSON();
	QJsonArray keys = orderskeys.array();

	qDebug() << "CommandLineInterface::orderSuccess" << keys.size();
	if ( keys.size() ) {
		int c = 0;
		foreach (const QJsonValue & v, keys) {
			c++;
			QJsonObject item = v.toObject();
			if ( c > 5 )
				break;
			this->downloadOrder(item["gamekey"].toString());
			this->task++;
		}
	} else {
		emit taskFailure("Orders", "No Orders Found");
	}
}

void CommandLineInterface::orderFailure() {
	qDebug() << "CommandLineInterface::orderFailure";
	emit taskFailure("Orders", "No Orders Found");
}

void CommandLineInterface::downloadTaskSuccess(int downloadID) {
	QVariantMap info = humble_download->getItemDetail(downloadID);
	qDebug() << "CommandLineInterface::taskSuccess" << downloadID << info["url"];

	humble_user->insertOrder(info["userKey"].toString(), info["content"].toString());

	this->checkForExit();
}

void CommandLineInterface::downloadTaskFailure(int downloadID) {
	QVariantMap info = humble_download->getItemDetail(downloadID);
	qDebug() << "CommandLineInterface::taskFailure" << info["url"];

	this->checkForExit();
}

void CommandLineInterface::taskSuccess( QString key, QString text) {
	qDebug() << "CommandLineInterface::taskSuccess" << key;
	humble_user->updateOrder(key, text);

	this->checkForExit();
}
void CommandLineInterface::taskFailure(QString key, QString text) {
	qDebug() << "CommandLineInterface::taskFailure" << key << text;

	this->checkForExit();
}

void CommandLineInterface::checkForExit() {
	this->task--;
	if ( this->task <= 0 )
		this->exitSuccessfully();
}

void CommandLineInterface::exitSuccessfully() {
	this->app->exit(0);
}

void CommandLineInterface::exitWithFailure() {
	this->app->exit(1);
}
