#ifndef HUMBLEDOWNLOAD_HPP
#define HUMBLEDOWNLOAD_HPP

#include <QObject>
#include "humblenetwork.hpp"


class HumbleDownload : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString url READ getUrl WRITE setUrl)
	Q_PROPERTY(double progress READ getProgressPercent)

public:
	explicit HumbleDownload(QObject *parent = 0);

	Q_INVOKABLE bool makeRequest( );
	Q_INVOKABLE double getProgressPercent( );
	Q_INVOKABLE QByteArray getContent( );
	Q_INVOKABLE QString getError( );
	Q_INVOKABLE bool writeContent( QString localFile );

	void setUrl(const QString &a);
	QString getUrl() const;

signals:
	void urlChanged();
	void downloadStarted();
	void progressUpdate();
	void appError();
	void appSuccess();

public slots:
	void progressChange( qint64 bytesReceived, qint64 bytesTotal );
	void downloadError( QString errorMessage );
	void downloadFinished( QByteArray content );

protected:
	double progress;
	QString url;
	HumbleNetworkRequest request;
	QString errorMessage;
	QByteArray content;
};

#endif // HUMBLEDOWNLOAD_HPP
