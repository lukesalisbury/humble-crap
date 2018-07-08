/****************************************************************************
* Copyright © Luke Salisbury
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

#include "local-cookie-jar.hpp"
#include <QDataStream>
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QNetworkCookie>
#include <QDebug>

/**
 * @brief LocalCookieJar::LocalCookieJar
 * @param user
 */
LocalCookieJar::LocalCookieJar(QString user)
{
	QDir dir;
	QString path = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);

	dir.mkpath(path);

	this->cookie_path = QDir(path).filePath(user + ".cookiejar" );

	this->LoadFromDisk();
}

/**
 * @brief LocalCookieJar::setCookiesFromUrl
 * @param cookieList
 * @param url
 * @return
 */
bool LocalCookieJar::setCookiesFromUrl(const QList<QNetworkCookie> &cookieList, const QUrl &url) {

	QNetworkCookieJar::setCookiesFromUrl(cookieList, url);
	this->SaveToDisk();
	return true;
}

/**

 */
void LocalCookieJar::empty() {
	foreach (QNetworkCookie cookie, this->allCookies())
	{
		this->deleteCookie(cookie);
	}
}

/**
 * @brief LocalCookieJar::SaveToDisk
 */
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

/**
 * @brief LocalCookieJar::LoadFromDisk
 */
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

}
