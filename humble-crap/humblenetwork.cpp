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
#include <zlib.h>

#include "humblenetwork.hpp"

QNetworkAccessManager * getNetworkManager();

QByteArray gUncompress(const QByteArray &data)
{
	if (data.size() <= 4)
	{
		qWarning("gUncompress: Input data is truncated");
		return QByteArray();
	}

	QByteArray result;

	int ret;
	z_stream strm;
	static const int CHUNK_SIZE = 1024;
	char out[CHUNK_SIZE];

	/* allocate inflate state */
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	strm.avail_in = data.size();
	strm.next_in = (Bytef*)(data.data());

	ret = inflateInit2(&strm, 15 + 32); // gzip decoding
	if (ret != Z_OK)
		return QByteArray();

	// run inflate()
	do {
		strm.avail_out = CHUNK_SIZE;
		strm.next_out = (Bytef*)(out);

		ret = inflate(&strm, Z_NO_FLUSH);
		Q_ASSERT(ret != Z_STREAM_ERROR); // state not clobbered

		switch (ret) {
			case Z_NEED_DICT:
				ret = Z_DATA_ERROR; // and fall through
			case Z_DATA_ERROR:
			case Z_MEM_ERROR:
				(void)inflateEnd(&strm);
				return QByteArray();
		}

		result.append(out, CHUNK_SIZE - strm.avail_out);
	} while (strm.avail_out == 0);

	// clean up and return
	inflateEnd(&strm);
	return result;
}

/**
 * @brief HumbleNetworkRequest::HumbleNetworkRequest
 * @param url
 * @param parent
 */
void HumbleNetworkRequest::getToken()
{
	connect( this, SIGNAL(contentFinished(QByteArray)), this, SLOT(finishRequestCookies(QByteArray)));
	this->makeRequest( QUrl("https://www.humblebundle.com/login") );
}

HumbleNetworkRequest::HumbleNetworkRequest() : cookiesRetrieved(0)
{
	/* Setup webManager */
	this->webManager = getNetworkManager();

	connect( this->webManager, SIGNAL( sslErrors(QNetworkReply*, const QList<QSslError>) ), SLOT( sslError(QNetworkReply*, const QList<QSslError> )));

	if ( !QSslSocket::supportsSsl() )
	{
		qDebug() << "OpenSSL not installed";
		this->errorMessage = "OpenSSL not installed";
		emit downloadError( this->errorMessage );
	}

}

/**
 * @brief HumbleNetworkRequest::appendPost
 * @param key
 * @param value
 */
void HumbleNetworkRequest::appendPost(QString key, QString value)
{
	if ( this->postData.length() > 0 )
	{
		this->postData.append("&");
	}

	this->postData.append(key);
	this->postData.append("=");
	this->postData.append(value);
}

/**
 * @brief HumbleNetworkRequest::retrieveContent
 * @return
 */
QByteArray HumbleNetworkRequest::retrieveContent()
{
	qDebug() << "retrieveContent";
	return this->downloadData;
}

/**
 * @brief HumbleNetworkRequest::writeContent
 * @param outputFile
 * @return
 */
bool HumbleNetworkRequest::writeContent(QString outputFile)
{
	qDebug() << "writeContent";
	QString path = QStandardPaths::writableLocation( QStandardPaths::DataLocation );
	QFile f(path + "/" + outputFile);

	f.open( QIODevice::WriteOnly|QIODevice::Truncate );
	f.write( this->downloadData );
	f.close();

	return true;
}

/**
 * @brief HumbleNetworkRequest::makeRequest
 * @return
 */
bool HumbleNetworkRequest::makeRequest( QUrl url )
{
	if ( QSslSocket::supportsSsl() )
	{

		QNetworkRequest request;
		request.setRawHeader("User-Agent", "Humble-bundle Content Retrieving APplication");
		request.setRawHeader("Content-Type", "application/x-www-form-urlencoded");
		request.setRawHeader("Accept-Encoding", "gzip,deflate,qcompress" );
		request.setRawHeader("Referer", "http://github.org/lukesalisbury/humble-crap" );
		request.setUrl( url );

		connect( this->webManager, SIGNAL( finished(QNetworkReply*) ), this, SLOT( finishRequest(QNetworkReply*)) );

		if ( this->postData.length() > 0 )
		{
			this->reply = this->webManager->post( request, this->postData.toPercentEncoding("=&") );
			this->postData.clear();
		}
		else
		{
			this->reply = this->webManager->get( request );
		}

		connect( reply, SIGNAL( downloadProgress( qint64, qint64 )), this, SLOT(downloadProgress( qint64, qint64 )) );
		return true;
	}
	return false;
}

QNetworkCookieJar *HumbleNetworkRequest::getCookies()
{
	return this->webManager->cookieJar();
}

/**
 * @brief HumbleNetworkRequest::finishRequestCookies
 * @param content
 */
void HumbleNetworkRequest::finishRequestCookies(QByteArray content)
{
	QNetworkCookieJar * cookies = this->webManager->cookieJar();
	QList<QNetworkCookie> list = cookies->cookiesForUrl( QUrl("https://www.humblebundle.com/") );

	qDebug() << "cookies:" << quint32(list.size());
	cookiesRetrieved = true;

	disconnect( this, SIGNAL(contentFinished(QByteArray)), NULL, NULL );
}

/**
 * @brief HumbleNetworkRequest::sslError
 * @param pReply
 * @param errors
 */
void HumbleNetworkRequest::sslError(QNetworkReply* pReply, const QList<QSslError> & errors )
{
	this->errorMessage = "SSL Error";
	emit downloadError( this->errorMessage );
}

/**
 * @brief HumbleNetworkRequest::downloadProgress
 * @param bytesReceived
 * @param bytesTotal
 */
void HumbleNetworkRequest::downloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
	emit progressUpdate(bytesReceived, bytesTotal);
}



/**
 * @brief HumbleNetworkRequest::finishRequest
 * @param pReply
 */
void HumbleNetworkRequest::finishRequest( QNetworkReply* pReply )
{
	if ( pReply == reply )
	{
		QVariant redirectionTarget = pReply->attribute(QNetworkRequest::RedirectionTargetAttribute);
		QUrl url = redirectionTarget.toUrl();

		pReply->deleteLater();

		disconnect(this->webManager, SIGNAL(finished(QNetworkReply*)), this, 0);

		if ( pReply->error() )
		{
			qDebug() << tr("Download failed: %1.").arg(pReply->errorString());
			this->errorMessage = pReply->errorString();
			emit downloadError( this->errorMessage );

			//disconnect(this, 0, 0, 0);
		}
		else if ( url.path() == "/login" )
		{
			qDebug() << tr("Login failed") << url.query();
			this->errorMessage = "Login failed";
			emit downloadError( this->errorMessage );

			//disconnect(this, 0, 0, 0);
		}
		else if ( url.isEmpty() )
		{
			this->downloadData = pReply->readAll();
			qDebug() << tr("Download Successful: %1").arg(pReply->url().toString() );
			emit contentFinished( this->downloadData );

			//disconnect(this, 0, 0, 0);
		}
		else
		{
			qDebug() << tr("New URL");
			this->makeRequest( url );
		}

	}

}
