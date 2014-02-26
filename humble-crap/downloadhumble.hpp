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
        Q_INVOKABLE void login(QString email, QString password , bool savePassword);

        Q_INVOKABLE void updateContent();
		Q_INVOKABLE QString getContent();

		Q_INVOKABLE void saveFile( QByteArray  content, QString as );
		Q_INVOKABLE void saveFile( QString content, QString as );
		Q_INVOKABLE void getFile(QString id, QString url);
		Q_INVOKABLE void openFile( QString file );

		Q_INVOKABLE QString getUsername();
		Q_INVOKABLE QString getPassword();
        Q_INVOKABLE bool getSavePassword();
        Q_INVOKABLE QString getErrorMessage();
	signals:
		void refresh();
		void downloaded(QString id, QString file);
		void downloadError();
        void appError();
        void appSuccess();

	public slots:
        void finishDownload( QNetworkReply* pReply );
        void finishLogin( QNetworkReply* pReply );
        void finishContent( QNetworkReply* pReply );

		void sslError(QNetworkReply* pReply, const QList<QSslError> & errors );
    protected:
        QString currentPassword;
        QString currentUser;
        QByteArray pageContent;

    private:
		QList<QNetworkReply *> currentDownloads;

        QNetworkAccessManager webManager;
        QByteArray downloadData;
        bool fileDownloading;
        bool loginSuccess;
		QSettings settings;
        QString errorMessage;
		QByteArray crapHeader;
};

#endif // DOWNLOADHUMBLE_HPP
