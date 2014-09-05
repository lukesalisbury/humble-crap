#ifndef DOWNLOADHUMBLE_HPP
#define DOWNLOADHUMBLE_HPP

#include <QObject>
#include <QtNetwork>
#include <QCoreApplication>
#include <iostream>


class HumbleCrap : public QObject
{
	Q_OBJECT
	public:
		explicit HumbleCrap(QObject *parent = 0);

		QByteArray readFile( QString file );
		void saveFile(QByteArray content, QString as);
		void saveFile(QString content, QString as);
		void downloadFile(QString id, QString url );
		void openFile( QString file );



		Q_INVOKABLE QString getUsername();
		Q_INVOKABLE QString getPassword();
		Q_INVOKABLE bool getSavePassword();

		Q_INVOKABLE void setUsername( QString email );
		Q_INVOKABLE void setPassword( QString password, bool save );

	signals:
		void refresh();
		void appError( QString errorMessage );
		void appSuccess();
	public slots:

	protected:

    private:
		QSettings settings;
		bool loginSuccess;
        QString errorMessage;
		QByteArray crapHeader;
};

#endif // DOWNLOADHUMBLE_HPP




