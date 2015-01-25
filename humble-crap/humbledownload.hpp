/****************************************************************************
* Copyright (c) 2015 Luke Salisbury
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

	Q_INVOKABLE QString getUrlFile();


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
