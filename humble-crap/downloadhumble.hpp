#ifndef DOWNLOADHUMBLE_HPP
#define DOWNLOADHUMBLE_HPP

#include <QObject>
#include <QtNetwork>
#include <QCoreApplication>
#include <iostream>


class DownloadHumble : public QObject
{
	Q_OBJECT
	public:
		explicit DownloadHumble(QObject *parent = 0);
		Q_INVOKABLE void go( QString email, QString password );
		Q_INVOKABLE QString getDownloadText();
		Q_INVOKABLE void saveFile( QString content, QString as );
		Q_INVOKABLE void downloadTorrent(QString urlString);
		Q_INVOKABLE void get(QString url, QString saveAs);
		Q_INVOKABLE QString getUsername();
		Q_INVOKABLE QString getPassword();
	signals:
		void downloaded();
		void downloadError();

	public slots:
		void fileDownloaded(QNetworkReply* pReply);
		void sslError(QNetworkReply* pReply, const QList<QSslError> & errors );
	private:
		QNetworkAccessManager m_WebCtrl;
		QByteArray m_DownloadedData;
		bool downloading;
		QSettings settings;

};

#endif // DOWNLOADHUMBLE_HPP
