#ifndef HUMBLENETWORK_HPP
#define HUMBLENETWORK_HPP

#include <QObject>
#include <QtNetwork>
#include <QCoreApplication>


class HumbleNetworkRequest : public QObject
{
	Q_OBJECT
	public:
		explicit HumbleNetworkRequest( );

		QByteArray retrieveContent();
		bool writeContent( QString outputFile );

		void appendPost( QString key, QString value );
		bool makeRequest( QUrl url );

	signals:
		void downloadError( QString errorMessage );
		void contentFinished( QByteArray content );
		void progressUpdate( qint64 bytesReceived, qint64 bytesTotal );

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
};

#endif // HUMBLENETWORK_HPP
