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
#ifndef HUMBLENETWORK_HPP
#define HUMBLENETWORK_HPP

#include <QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QtCore>
#include <QNetworkCookieJar>
#include <QNetworkCookie>

#include "local-cookie-jar.hpp"

class HumbleNetworkRequest : public QObject
{
	Q_OBJECT
	public:
		explicit HumbleNetworkRequest( );

		QByteArray retrieveContent();
		bool writeContent( QString outputFile );

		void appendPost( QString key, QString value );
		bool makeRequest(QUrl url, QString requester = "XMLHttpRequest");

		QNetworkCookieJar * getCookies();
		bool setCookies(QNetworkCookieJar * cookies_jar);
		void printCookies();

	signals:
		void requestError( QString errorMessage,  QByteArray content, qint16 httpCode );
		void requestSuccessful( QByteArray content );
		void requestProgress( qint64 bytesReceived, qint64 bytesTotal );

	public slots:
		void finishRequest( QNetworkReply* pReply );
		void sslError( QNetworkReply* pReply, const QList<QSslError> & errors );
		void downloadProgress ( qint64 bytesReceived, qint64 bytesTotal );
	private:
		QNetworkReply * reply;
		QNetworkAccessManager * webManager;
		QByteArray downloadData;
		QString errorMessage;
		QByteArray postData;
	public:
		bool sslMissing;
		QString csrfPreventionToken = "";
};

#endif // HUMBLENETWORK_HPP
