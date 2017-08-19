#include "local-cookie-jar.hpp"
#include <QDataStream>
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QNetworkCookie>
#include <QDebug>

LocalCookieJar::LocalCookieJar(QString user)
{
	QString path = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
	cookie_path = QDir(path).filePath("cookiejar-" + user);

	this->LoadFromDisk();
}

void LocalCookieJar::SaveToDisk() {

	QFile file(cookie_path);
	file.open(QIODevice::WriteOnly);

	QDataStream out(&file);
	QList<QNetworkCookie> cookies = this->allCookies();
	for (int i = 0; i < cookies.size(); ++i) {
		QNetworkCookie c = cookies.at(i);
		out << c.toRawForm();
	}

	file.close();
}

void LocalCookieJar::LoadFromDisk() {
	QList<QNetworkCookie> cookies;
	QList<QNetworkCookie> single_cookie;
	QFile file(cookie_path);
	file.open(QIODevice::ReadOnly);

	QDataStream in(&file);


	while (!in.atEnd()) {
		QByteArray data;
		in >> data;
		single_cookie = QNetworkCookie::parseCookies(data);
		for (int i = 0; i < single_cookie.size(); ++i) {
			cookies.append(single_cookie.at(i));
		}

	}


	this->setAllCookies(cookies);

	qDebug() << "cookies:" << quint32(cookies.size());
	qDebug() << "List" << cookies;
}
