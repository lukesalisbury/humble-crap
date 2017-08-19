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

#include "humble-download.hpp"

/**

   @param parent
 */
HumbleDownload::HumbleDownload(QObject *parent) : QObject(parent)
{
	this->progress = 0.0;
}

/**

   @return
 */
bool HumbleDownload::makeRequest()
{
	if ( !this->url.isEmpty() )
	{
		connect( &this->request, SIGNAL( requestError(QString) ), this, SLOT( requestError(QString)) );
		connect( &this->request, SIGNAL( requestProgress(qint64,qint64) ), this, SLOT( progressChange(qint64,qint64) ) );
		connect( &this->request, SIGNAL( requestSuccessful(QByteArray) ), this, SLOT( downloadFinished(QByteArray) ));

		if ( this->request.makeRequest( QUrl(this->url) ) )
		{
			emit downloadStarted();
			return true;
		}
	}
	return false;
}

/**

   @param localFile
   @return
 */
bool HumbleDownload::writeContent( QString localFile )
{
	QByteArray data;
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );

	QFile f(path + "/" + localFile );
	f.open( QIODevice::ReadOnly );
	data = f.readAll();

	f.close();

	return true;
}


double HumbleDownload::getProgressPercent()
{
	return this->progress;
}

QByteArray HumbleDownload::getContent()
{
	return this->content;
}

QString HumbleDownload::getError()
{
	return this->errorMessage;
}

QString HumbleDownload::getUrlFile()
{
	QUrl address = QUrl(this->url);


	return address.path();
}


void HumbleDownload::setUrl(const QString &a)
{
	this->url = a;
	emit urlChanged();
}

QString HumbleDownload::getUrl() const
{
	return this->url;
}

void HumbleDownload::progressChange(qint64 bytesReceived, qint64 bytesTotal)
{
	if ( bytesTotal <= 0 )
	{
		this->progress += 0.1;
	}
	else
	{
		this->progress = (double)bytesReceived / (double)bytesTotal;
	}
	emit requestProgress();
}

void HumbleDownload::requestError(QString errorMessage)
{
	this->errorMessage = errorMessage;
	emit appError();
}

void HumbleDownload::downloadFinished(QByteArray content)
{
	this->content = content;
	emit appSuccess();
}
