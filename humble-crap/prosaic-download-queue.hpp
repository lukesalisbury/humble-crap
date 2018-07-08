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
#ifndef PROSAICDOWNLOADQUEUE_HPP
#define PROSAICDOWNLOADQUEUE_HPP

#include <QObject>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QtCore>
#include <QNetworkCookieJar>
#include <QNetworkCookie>


#if defined(WIN32)
	#define BREAKPOINT() *((int *) NULL) = 0; exit(3);
#else
	#define BREAKPOINT() raise(SIGABRT);
#endif


class ProsaicDownloadQueue;

class DownloadItem: public QObject
{
	Q_OBJECT
	public:
		DownloadItem(QString owner, QUrl address, QString outputFilename);
		DownloadItem() {}

	public slots:
		void requestWrite();
		void requestCompleted();
		void requestProgress(qint64 bytesReceived, qint64 bytesTotal);
		void requestError(QNetworkReply::NetworkError code);

	public:
		ProsaicDownloadQueue * parentQueue = nullptr;
		QNetworkReply * networkReply = nullptr;
		QFile * file = nullptr;

		QString filename = "";
		QString temporaryFilename = "";
		QString owner = "";
		QString userKey = "";
		QUrl address = QUrl("");
		quint8 state = 0; // { Pause, Running, completed }

		int id = 0;
		bool eventsSet = false;
		bool cache = false;
		bool resumable = false;
		bool returnContent = false;

		qint64 fileSize = 0;
		qint64 existSize = 0;
		qint64 downloadSize = 0;

	public:
		QVariantMap getItemDetail();
		QVariantMap getFullDetail();

		void start(QNetworkReply * reply);
		void pause();
		void cancel();

		void setup();
};


class ProsaicDownloadQueue: public QObject
{
	Q_OBJECT
	public:
		ProsaicDownloadQueue();
		~ProsaicDownloadQueue();

	signals:
		void error( int id, QNetworkReply::NetworkError code);
		void completed( int id );
		void progress( int id, qint64 bytesReceived, qint64 bytesTotal);
		void updated();

	private:
		QNetworkAccessManager * webmanager = nullptr;

	protected:

	public:
		Q_PROPERTY(QVariantList items READ getItemList)

		QList<DownloadItem*> queue;

		QVariantList getItemList();
		Q_INVOKABLE QVariantMap getItemDetail(int id);

		Q_INVOKABLE bool changeDownloadItemState(int id, qint8 state);
		Q_INVOKABLE void ableUserDownloadItem( QString user, qint8 state);
		Q_INVOKABLE int append(QString url, QString as, QString userKey, bool returnData = false);

		Q_INVOKABLE void openDirectory(int id);

		void startDownloadItem(DownloadItem * item);
		void pauseDownloadItem(DownloadItem * item);
		void cancelDownloadItem(DownloadItem * item);

};

#endif // HUMBLEDOWNLOADQUEUE_HPP

